require "ncurses"
require "terminfo"
require_relative 'chat_channel'
require_relative 'mock_channel_fetcher'

class ChatUI
	def initialize(userinfo)
		@userinfo = userinfo
		@buffer = ""
		@cursor_pos = 0
		@scroll_height = 0
		@channel = ChatChannel.new(MockChannelFetcher.new)
		@maxx = 0
		@maxy = 0
		@quit = false

		@chatlog
		@input
	end

	def init_draw
		Ncurses.initscr
		Ncurses.cbreak
		Ncurses.noecho
		@maxy,@maxx = TermInfo.screen_size
	end

	def get_channel_lines
		messages = @channel.get_messages
		lines = []
		messages.reverse_each do |message|
			printed_msg = "#{message.time} <#{message.author}> #{message.message}" #TODO: Make this a dedicated class
			message_pieces = printed_msg.chars.each_slice(@maxx-2).map(&:join)
			message_pieces.reverse_each do |piece|
				lines.push(piece)
			end
		end
		lines
	end

	def draw_channel
		@chatlog.clear
		Ncurses.box(@chatlog,0,0)
		start = @scroll_height
		cursor = @maxy-5
		msgs = get_channel_lines
		(@maxy-5).times do |i|
			@chatlog.move(cursor,1)
			@chatlog.addstr("#{msgs[i+start]}")
			cursor -= 1
		end
		@chatlog.wrefresh
	end

	def channel_heartbeat_thread
		loop do
			@channel.heartbeat
			draw_channel
			sleep 2
		end
	end

	def draw_input_buffer
		@input.clear
		Ncurses.box(@input,0,0)
		userstr = "[#{@userinfo.username}] ";
		userstr_len = userstr.length
		loop do
			@input.mvaddstr(1,1,userstr)
			@input.mvaddstr(1,userstr_len+1,@buffer)
			@input.move(1,userstr_len+1+@cursor_pos)
			ch = @input.getch
			case ch
				when Ncurses::KEY_LEFT
					@cursor_pos = [0,@cursor_pos-1].max
				when Ncurses::KEY_RIGHT
					@cursor_pos = [@buffer.length,@cursor_pos+1].min
				when Ncurses::KEY_BACKSPACE, 127
					@buffer = @buffer[0...([0, @cursor_pos-1].max)] + @buffer[@cursor_pos..-1]
					@cursor_pos = [0,@cursor_pos-1].max
					@input.mvaddstr(1,userstr_len+1+@buffer.length, " ")
				when Ncurses::KEY_DC
					@buffer = @cursor_pos == @buffer.size ? @buffer : @buffer[0...([0, @cursor_pos].max)] + @buffer[(@cursor_pos+1)..-1]
					@input.mvaddstr(1, userstr_len+1+@buffer.length, " ")
				when Ncurses::KEY_ENTER, "\n".ord, "\r".ord
					if @buffer.strip != ""
						@cursor_pos = 0
						buffer = @buffer
						@buffer = ""
						return buffer
					end
				when 27
					@input.nodelay(true)
    			n = @input.getch()
					if n == -1
						@quit = true
						return
					end
					@input.nodelay(false)
				when 0..255
					@buffer = @buffer[0..@cursor_pos-1] + ch.chr + @buffer[@cursor_pos..-1]
					@cursor_pos+=1
			end
			@input.wrefresh
		end
	end

	def draw_windows
		in_height = 3;
		@chatlog = Ncurses::WINDOW.new(Ncurses.LINES-in_height,Ncurses.COLS,0,0)
		@input = Ncurses::WINDOW.new(in_height,Ncurses.COLS,Ncurses.LINES-in_height,0)
		Ncurses.box(@chatlog,0,0)
		Ncurses.box(@input,0,0)
		@input.wrefresh
		@chatlog.wrefresh
		@input.keypad(true)
		server = Thread.new do
			channel_heartbeat_thread
		end
		loop do
			msg = draw_input_buffer.strip
			if msg != "/quit" and msg != ":quit" and msg != ""
				@channel.send_message msg
			else
				@quit = true
			end
			break if @quit
		end
		server.kill
	end

	def run
		init_draw
		draw_windows
		Ncurses.echo
		Ncurses.endwin
	end
end

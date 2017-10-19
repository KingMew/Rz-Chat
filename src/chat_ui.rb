require "curses"
require "terminfo"
require_relative 'chat_channel'
require_relative 'mock_channel_fetcher'
require_relative 'message_formatter'
class Curses::Window
	def mvaddstr(y,x,str)
		setpos(y,x)
		addstr(str)
	end
end
class ChatUI
	def initialize(userinfo)
		@userinfo = userinfo
		@buffer = "test message"
		@cursor_pos = 0
		@scroll_height = 0
		@channel = ChatChannel.new(MockChannelFetcher.new)
		@maxx = 0
		@maxy = 0
		@quit = false

		@chatlog
		@input
		@error
	end

	def init_draw
		init_pairs
		Curses.init_screen
		Curses.cbreak
		Curses.noecho
		@maxy,@maxx = TermInfo.screen_size
	end

	def init_pairs
		Curses.init_pair(1, Curses::COLOR_RED, Curses::COLOR_BLACK)
		Curses.init_pair(2, Curses::COLOR_GREEN, Curses::COLOR_BLACK)
		Curses.init_pair(3, Curses::COLOR_YELLOW, Curses::COLOR_BLACK)
		Curses.init_pair(4, Curses::COLOR_BLUE, Curses::COLOR_BLACK)
		Curses.init_pair(5, Curses::COLOR_MAGENTA, Curses::COLOR_BLACK)
		Curses.init_pair(6, Curses::COLOR_CYAN, Curses::COLOR_BLACK)
	end

	def get_channel_lines
		messages = @channel.get_messages
		lines = []
		formatter = MessageFormatter.new(@maxx-2)
		messages.reverse_each do |message|
			message_pieces = formatter.format(message)
			message_pieces[0] = "!#{message.time};#{message.author};#{message_pieces[0]}"
			message_pieces.reverse_each do |piece|
				lines.push(piece)
			end
		end
		lines
	end

	def draw_channel
		@maxy,@maxx = TermInfo.screen_size
		@chatlog.clear
		@chatlog.box(0,0)
		start = @scroll_height
		cursor = @maxy-5
		msgs = get_channel_lines
		(@maxy-5).times do |i|
			message = msgs[i+start]
			if message != nil
				if message[0] == "!"
					pieces = msgs[i+start][1..-1].split(";")
					time = pieces[0]
					author = pieces[1]
					message = pieces[2..-1].join(";")
					message = "#{time} <#{author}> #{message}"
					@chatlog.setpos(cursor,1)
					@chatlog.addstr("#{message}") #TODO: colorize, baby
				else
					@chatlog.setpos(cursor,1)
					@chatlog.addstr("#{message}")
				end
			end
			cursor -= 1
			@chatlog.refresh
		end
		@chatlog.refresh
	end

	def channel_heartbeat_thread
		draw_channel
		draw_channel
		loop do
			@channel.heartbeat
			draw_channel
			sleep 2
		end
	end

	def draw_input_buffer
		@input.clear
		@input.box(0,0)
		userstr = "[#{@userinfo.username}] ";
		userstr_len = userstr.length
		loop do
			@input.mvaddstr(1,1,userstr)
			@input.mvaddstr(1,userstr_len+1,@buffer)
			@input.setpos(1,userstr_len+1+@cursor_pos)
			ch = @input.getch
			case ch.ord
				when Curses::KEY_LEFT
					@cursor_pos = [0,@cursor_pos-1].max
				when Curses::KEY_RIGHT
					@cursor_pos = [@buffer.length,@cursor_pos+1].min
				when Curses::KEY_BACKSPACE, 127
					@buffer = @buffer[0...([0, @cursor_pos-1].max)] + @buffer[@cursor_pos..-1]
					@cursor_pos = [0,@cursor_pos-1].max
					@input.mvaddstr(1,userstr_len+1+@buffer.length, " ")
				when Curses::KEY_DC
					@buffer = @cursor_pos == @buffer.size ? @buffer : @buffer[0...([0, @cursor_pos].max)] + @buffer[(@cursor_pos+1)..-1]
					@input.mvaddstr(1, userstr_len+1+@buffer.length, " ")
				when Curses::KEY_ENTER, "\n".ord, "\r".ord
					if @buffer.strip != ""
						@cursor_pos = 0
						buffer = @buffer
						@buffer = ""
						return buffer
					end
				when 27
					@input.nodelay=true
    			n = @input.getch()
					if n == -1
						@quit = true
						return
					end
					@input.nodelay=false
				when 0..255
					@buffer = @buffer[0..@cursor_pos-1] + ch.chr + @buffer[@cursor_pos..-1]
					@cursor_pos+=1
			end
			@input.refresh
		end
	end

	def draw_windows
		in_height = 3;
		@chatlog = Curses::Window.new(@maxy-in_height,@maxx,0,0)
		@input = Curses::Window.new(in_height,@maxx,@maxy-in_height,0)
		@chatlog.box(0,0)
		@input.box(0,0)
		@input.refresh
		@chatlog.refresh
		@input.keypad(true)
		server = Thread.new do
			begin
				channel_heartbeat_thread
			rescue Exception => e
				@quit = true
				@error = e.message+"\n"+e.backtrace.join("\n")
				puts @error
			end
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
		Curses.echo
		Curses.nocbreak
		Curses.close_screen
		puts @error
	end
end

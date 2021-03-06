require "curses"
require "terminfo"
require_relative '../core/chat_channel'
require_relative '../net/mock_channel_fetcher'
require_relative '../net/rz_web_channel_fetcher'
require_relative 'message_formatter'
require_relative 'nick_color'
require_relative 'beepcmd'
class Curses::Window
	def mvaddstr(y,x,str)
		setpos(y,x)
		addstr(str)
	end
end
class ChatUI
	def initialize(userinfo,beepcmd)
		@userinfo = userinfo
		@buffer = ""
		@cursor_pos = 0
		@scroll_height = 0
		@channels = [ChatChannel.new(RzWebChannelFetcher.new(@userinfo.sessionid,"1")),ChatChannel.new(RzWebChannelFetcher.new(@userinfo.sessionid,"2"))]
		@current_channel = 0
		@maxx = 0
		@maxy = 0
		@quit = false
		@beepcmd = BeepCmd.new(beepcmd)

		@chatlog
		@input
		@userlist
		@error
	end

	def get_current_channel
		@channels[@current_channel]
	end

	def channel_heartbeat
		new_messages = false
		@channels.each do |channel|
			channel.heartbeat
			new_messages = new_messages || channel.has_new_messages?
		end
		if new_messages
			@beepcmd.execute
		end
	end

	def init_draw
		Curses.init_screen
		Curses.start_color
		init_pairs
		Curses.cbreak
		Curses.noecho
		@maxy,@maxx = TermInfo.screen_size
	end

	def init_pairs
		Curses.use_default_colors
		Curses.init_pair(1, Curses::COLOR_RED, -1)
		Curses.init_pair(2, Curses::COLOR_GREEN, -1)
		Curses.init_pair(3, Curses::COLOR_YELLOW, -1)
		Curses.init_pair(4, Curses::COLOR_BLUE, -1)
		Curses.init_pair(5, 175, -1)
		Curses.init_pair(6, Curses::COLOR_CYAN, -1)
		if Curses.can_change_color?
			Curses.init_pair(7, 240, -1)
		else
			Curses.init_pair(7,Curses::COLOR_WHITE, -1)
		end
		Curses.init_pair(8, 120,-1)
		Curses.init_pair(9, 94,-1) #MUSTARD BOYZ
		Curses.init_pair(10, 202,-1)
		Curses.init_pair(11, 131,-1)
		Curses.init_pair(12, 82,-1)
		Curses.init_pair(13, 198,-1)
		Curses.init_pair(14, 99,-1)
		Curses.init_pair(15, 100,-1)
	end

	def get_channel_lines
		messages = get_current_channel.get_messages
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

	def draw_userlist
		@userlist.clear
		@userlist.box(0,0)
		@userlist.setpos(0,1)
		@userlist.addstr(get_current_channel.channel_name)
		@userlist.setpos(1,1)
		users = get_current_channel.userlist
		users.each_with_index do |user, index|
			color = NickColor.new(user).getColor
			if color > -1
				@userlist.attron(Curses.color_pair(color))
				@userlist.addstr(user)
				@userlist.attroff(Curses.color_pair(color))
			else
				@userlist.addstr(user)
			end
			@userlist.addstr(", ") unless index == users.size-1
		end
	end

	def draw_channel
		@maxy,@maxx = TermInfo.screen_size
		@chatlog.clear
		@chatlog.box(0,0)
		start = @scroll_height
		cursor = @maxy-(3)*2-2
		msgs = get_channel_lines
		(@maxy-(3)*2-2).times do |i|
			message = msgs[i+start]
			if message != nil
				if message[0] == "!"
					pieces = msgs[i+start][1..-1].split(";")
					time = pieces[0]
					author = pieces[1]
					message = pieces[2..-1].join(";")
					color = NickColor.new(author).getColor
					@chatlog.setpos(cursor,1)
					@chatlog.attron(Curses.color_pair(7))
					@chatlog.addstr("#{time} ")
					@chatlog.attroff(Curses.color_pair(7))
					if message.slice(0,4) != "/me "
						@chatlog.addstr("<")
						if color > -1
							@chatlog.attron(Curses.color_pair(color))
							@chatlog.addstr(author)
							@chatlog.attroff(Curses.color_pair(color))
						else
							@chatlog.addstr(author)
						end
						@chatlog.addstr("> #{message}")
					else
						@chatlog.attron(Curses.color_pair(color))
						@chatlog.attron(Curses::A_BOLD)
						@chatlog.addstr("*#{author}  ")
						@chatlog.attroff(Curses::A_BOLD)
						@chatlog.attroff(Curses.color_pair(color))
						@chatlog.addstr("#{message[4..-1]}")
					end
				else
					@chatlog.setpos(cursor,1)
					@chatlog.addstr("#{message}")
				end
			end
			cursor -= 1
			@chatlog.refresh
		end
		@chatlog.refresh
		draw_userlist
		@userlist.refresh
		reset_cursor
	end

	def channel_heartbeat_thread
		draw_channel
		draw_channel
		loop do
			channel_heartbeat
			draw_channel
			sleep 2
			break if @quit
		end
	end

	def reset_cursor
		userstr = "[#{@userinfo.username}] ";
		userstr_len = userstr.length
		@input.setpos(1,userstr_len+1+@cursor_pos)
	end

	def draw_input_buffer
		@input.clear
		@input.box(0,0)
		userstr = "[#{@userinfo.username}] ";
		userstr_len = userstr.length
		color = NickColor.new(@userinfo.username).getColor
		loop do
			@input.mvaddstr(1,1,"[")
			if color > -1
				@input.attron(Curses.color_pair(color))
				@input.attron(Curses::A_BOLD)
				@input.addstr(@userinfo.username)
				@input.attroff(Curses::A_BOLD)
				@input.attroff(Curses.color_pair(color))
			else
				@input.addstr(@userinfo.username)
			end
			@input.addstr("] ");
			@input.mvaddstr(1,userstr_len+1,@buffer)
			reset_cursor
			ch = @input.getch
			case ch.ord
				when Curses::KEY_LEFT
					@cursor_pos = [0,@cursor_pos-1].max
				when Curses::KEY_RIGHT
					@cursor_pos = [@buffer.length,@cursor_pos+1].min
				when Curses::KEY_HOME
					@cursor_pos = 0
				when Curses::KEY_END
					@cursor_pos = @buffer.size
				when Curses::KEY_BACKSPACE, 127
					@buffer = @buffer[0...([0, @cursor_pos-1].max)] + @buffer[@cursor_pos..-1]
					@cursor_pos = [0,@cursor_pos-1].max
					@input.mvaddstr(1,userstr_len+1+@buffer.length, " ")
				when Curses::KEY_DC
					@buffer = @cursor_pos == @buffer.size ? @buffer : @buffer[0...([0, @cursor_pos].max)] + @buffer[(@cursor_pos+1)..-1]
					@input.mvaddstr(1, userstr_len+1+@buffer.length, " ")
				when Curses::KEY_F5
					@current_channel = (@current_channel+1) % @channels.length
					draw_channel
				when Curses::KEY_F6
					@current_channel = (@current_channel-1) % @channels.length
					draw_channel
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
					@buffer = @cursor_pos == 0 ? ch.chr+@buffer : @buffer[0..([0,@cursor_pos-1].max)] + ch.chr + @buffer[@cursor_pos..-1]
					@cursor_pos+=1
			end
			@input.refresh
		end
	end

	def draw_windows
		in_height = 3;
		@chatlog = Curses::Window.new(@maxy-in_height*2,@maxx,in_height,0)
		@input = Curses::Window.new(in_height,@maxx,@maxy-in_height,0)
		@userlist = Curses::Window.new(in_height,@maxx,0,0)
		@chatlog.box(0,0)
		@input.box(0,0)
		@userlist.box(0,0)
		@input.refresh
		@chatlog.refresh
		@userlist.refresh
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
		trap("INT") {
			server.exit
			close_draw
			puts "Received interrupt signal."
			exit!
		}
		loop do
			msg = draw_input_buffer.strip
			if msg != "/quit" and msg != ":quit" and msg != ""
				get_current_channel.send_message msg
			else
				@quit = true
			end
			break if @quit
		end
		server.exit
	end

	def close_draw
		Curses.nocbreak
		Curses.echo
		@chatlog.refresh
		@input.refresh
		@userlist.refresh
		@chatlog.close
		@input.close
		@userlist.close
		Curses.refresh
		Curses.clear
		sleep 2
		Curses.close_screen
	end

	def run
		init_draw
		begin
			draw_windows
		ensure
			close_draw
		end
		puts @error
	end
end

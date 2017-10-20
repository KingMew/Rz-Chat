require_relative 'message_parser'

class ChatChannel
	def initialize(channel_fetcher)
		@heartbeat = channel_fetcher
		@messages = []
		@lastMessageId = 0
	end

	def channel_name
		@heartbeat.channel_name
	end

	def userlist
		@heartbeat.get_userlist
	end

	def heartbeat(newmsgcmd="")
		parser = MessageParser.new(@heartbeat.fetch_heartbeat @lastMessageId)
		new_messages = parser.parse
		if new_messages.size > 0 and newmsgcmd != ""
			pid = spawn(newmsgcmd+" >/dev/null 2>&1")
			Process.detach(pid)
		end
		@messages = @messages.concat(new_messages)
		@lastMessageId = @messages.last.id
	end

	def send_message(msg)
		@heartbeat.send_message(msg)
	end

	def get_messages
		return @messages
	end
end

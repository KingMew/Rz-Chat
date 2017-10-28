require_relative 'message_parser'

class ChatChannel
	def initialize(channel_fetcher)
		@heartbeat = channel_fetcher
		@messages = []
		@lastMessageId = 0
		@last_message_count = 0
	end

	def channel_name
		@heartbeat.channel_name
	end

	def userlist
		@heartbeat.get_userlist
	end

	def has_new_messages?
		@last_message_count < @messages.size
	end

	def heartbeat()
		@last_message_count = @messages.size
		parser = MessageParser.new(@heartbeat.fetch_heartbeat @lastMessageId)
		@messages = @messages.concat(parser.parse)
		if @messages.size > 0
			@lastMessageId = @messages.last.id
		end
	end

	def send_message(msg)
		@heartbeat.send_message(msg)
	end

	def get_messages
		return @messages
	end
end

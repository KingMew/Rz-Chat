require_relative 'message_parser'

class ChatChannel
	def initialize(channel_fetcher)
		@heartbeat = channel_fetcher
		@messages = []
	end

	def heartbeat
		parser = MessageParser.new(@heartbeat.fetchHeartbeat)
		@messages = @messages.concat(parser.parse)
	end

	def getMessages
		return @messages
	end
end

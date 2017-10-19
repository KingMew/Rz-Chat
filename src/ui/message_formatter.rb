class MessageFormatter
	def initialize(maxx)
		@maxx = maxx
	end

	def format(message)
		signature = "#{message.time} <#{message.author}> "
		printed_msg = "#{message.message}"
		if signature.length+printed_msg.length < @maxx
			return [printed_msg]
		else
			first_piece = printed_msg[0..@maxx-signature.length-1]
			remaining_string = printed_msg[@maxx-signature.length..-1]
			message_pieces = remaining_string.chars.each_slice(@maxx-signature.length).map(&:join)
			message_pieces = message_pieces.map do |piece|
				" "*signature.length+piece
			end
			return [first_piece].concat(message_pieces)
		end
	end
end

require_relative '../src/chat_channel'
require_relative '../src/mock_channel_fetcher'

describe ChatChannel do
	before :each do
		@channel = ChatChannel.new(MockChannelFetcher.new)
	end
	describe '.get_messages' do
		it 'should start out with no messages' do
			expect(@channel.get_messages).to be_empty
		end
	end

	describe '.heartbeat' do
		it 'should be able to heartbeat' do
			@channel.heartbeat
			expect(@channel.get_messages.length).to eq 10
		end
		it 'should keep old messages' do
			@channel.heartbeat
			@channel.heartbeat
			expect(@channel.get_messages.length).to eq 10
		end
	end

	describe '.send_message' do
		it 'should be able to send messages' do
			msg_text = 'The RZ were better before the drummer left'
			@channel.heartbeat
			@channel.send_message msg_text
			@channel.heartbeat
			expect(@channel.get_messages[10].message).to eq msg_text
		end
	end
end

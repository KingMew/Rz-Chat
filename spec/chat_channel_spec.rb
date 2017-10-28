require_relative '../src/core/chat_channel'
require_relative '../src/net/mock_channel_fetcher'

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

	describe '.has_new_messages?' do
		it 'should be able to see new messages' do
			expect(@channel.has_new_messages?).to be_falsey
			@channel.heartbeat
			expect(@channel.has_new_messages?).to be_truthy
			@channel.heartbeat
			expect(@channel.has_new_messages?).to be_falsey
		end
	end

	describe 'userlist and channel name' do
		it 'should get channel name' do
			@channel.heartbeat
			expect(@channel.channel_name).to eq 'Test Chat'
		end
		it 'should get user list' do
			@channel.heartbeat
			expect(@channel.userlist).to_not be_empty
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

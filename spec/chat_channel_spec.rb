require_relative '../src/chat_channel'
require_relative '../src/mock_channel_fetcher'

describe ChatChannel do
	before :each do
		@channel = ChatChannel.new(MockChannelFetcher.new)
	end
	describe '.getMessages' do
		it "should start out with no messages" do
			expect(@channel.getMessages).to be_empty
		end
	end

	describe '.heartbeat' do
		it "should be able to heartbeat" do
			@channel.heartbeat
			expect(@channel.getMessages.length).to eq 11
		end
		it "should keep old messages" do
			@channel.heartbeat
			@channel.heartbeat
			expect(@channel.getMessages.length).to eq 11
		end
	end
end

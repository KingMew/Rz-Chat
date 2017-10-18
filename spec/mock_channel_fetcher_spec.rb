require_relative '../src/mock_channel_fetcher'

describe MockChannelFetcher do
	describe '.new' do
		it "should be creatable" do
			MockChannelFetcher.new
		end
	end
	describe 'fetchHeartbeat' do
		it "should return some data" do
			heartbeat = MockChannelFetcher.new
			expect(heartbeat.fetchHeartbeat).not_to eq ''
		end
		it 'should stop returning data on subsequent heartbeats' do
			heartbeat = MockChannelFetcher.new
			heartbeat.fetchHeartbeat
			expect(heartbeat.fetchHeartbeat).to eq ''
		end
	end
end

require_relative '../src/mock_channel_fetcher'

describe MockChannelFetcher do
	describe 'fetch_heartbeat' do
		it 'should return some data' do
			heartbeat = MockChannelFetcher.new
			expect(heartbeat.fetch_heartbeat).not_to eq ''
		end
		it 'should stop returning data on subsequent heartbeats' do
			heartbeat = MockChannelFetcher.new
			heartbeat.fetch_heartbeat
			expect(heartbeat.fetch_heartbeat).to eq ''
		end
	end
end

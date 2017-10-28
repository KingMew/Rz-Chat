require_relative '../src/net/mock_channel_fetcher'

describe MockChannelFetcher do
	before :each do
		@heartbeat = MockChannelFetcher.new
	end
	describe 'fetch_heartbeat' do
		it 'should return some data' do
			expect(@heartbeat.fetch_heartbeat(0)).not_to eq ''
		end
		it 'should stop returning data on subsequent heartbeats without sent messages' do
			@heartbeat.fetch_heartbeat(0)
			expect(@heartbeat.fetch_heartbeat(0)).to eq ''
		end
	end
	describe 'send_message' do
		it 'should get our sent messages' do
			@heartbeat.fetch_heartbeat(0)
			@heartbeat.send_message 'The RZ were better before the drummer left'
			expect(@heartbeat.fetch_heartbeat(0)).not_to eq ''
		end
	end
end

require_relative '../src/net/mock_channel_fetcher'

describe MockChannelFetcher do
	before :each do
		@heartbeat = MockChannelFetcher.new
	end
	describe 'fetch_heartbeat' do
		it 'should return some data' do
			expect(@heartbeat.fetch_heartbeat).not_to eq ''
		end
		it 'should stop returning data on subsequent heartbeats without sent messages' do
			@heartbeat.fetch_heartbeat
			expect(@heartbeat.fetch_heartbeat).to eq ''
		end
	end
	describe 'send_message' do
		it 'should get our sent messages' do
			@heartbeat.fetch_heartbeat
			@heartbeat.send_message 'The RZ were better before the drummer left'
			expect(@heartbeat.fetch_heartbeat).not_to eq ''
		end
	end
end

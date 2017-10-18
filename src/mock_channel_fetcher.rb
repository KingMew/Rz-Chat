class MockChannelFetcher
	def initialize
		@first = true
	end
	def fetch_heartbeat
		if(@first)
			@first = false
			return ( File.open(File.expand_path(File.dirname(__FILE__))+"/../spec/mockdata/chat_sample.txt", "rb").read )
		else
			return ''
		end
	end
end

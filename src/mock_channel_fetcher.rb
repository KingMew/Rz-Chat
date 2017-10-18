class MockChannelFetcher
	def fetchHeartbeat
		return ( File.open(File.expand_path(File.dirname(__FILE__))+"/../spec/mockdata/chat_sample.txt", "rb").read )
	end
end

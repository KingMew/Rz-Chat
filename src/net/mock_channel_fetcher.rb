class MockChannelFetcher
	def initialize
		@first = true
		@msg_id = 215015
		@sent_messages = []
	end
	def fetch_heartbeat
		if(@first)
			@first = false
			return ( File.open(File.expand_path(File.dirname(__FILE__))+"/../../spec/mockdata/chat_sample.txt", "rb").read )
		else
			msgs = @sent_messages.join('\n')
			@sent_messages = []
			return msgs
		end
	end
	def send_message(msg_text)
		msg = '<div class="chatLine" id="message_'+@msg_id.to_s+'"><span class="picBox"><img class="profilePic" src="userpics/moleshow.jpg?1485207571"/></span><span class="message"><span class="date" data-localtime-format>2017-10-13 12:13:53</span><br /><span class="userName">mewee</span>: '+msg_text+'</span></div>';
		@sent_messages.push(msg)
	end
end

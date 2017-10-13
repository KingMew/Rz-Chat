class MessageParser
	Message = Struct.new("Message",:id,:time,:author,:message)
	def initialize(htmldata)
		@data = htmldata
	end

	def convert_emojis(msg)
		emojiTemplate = /<img (.+?) src="(emoji|stickers)\/(.+?)\.png" (.+?) \/>/i
		msg.gsub(emojiTemplate,":\\3:");
	end

	def clean_message(msg)
		msg.gsub!(/<\/?span>/i,"");
		msg = CGI.unescapeHTML(msg)
		msg = convert_emojis(msg)
		msg = clean_urls(msg)
		return msg.strip
	end

	def clean_timestamp(time)
		pieces = time.split(" ")
		return pieces[1][0..7]
	end

	def clean_urls(msg)
		urlTemplate = /<a href="(.+?)" target="_blank">\1<\/a>/im
		pageCardTemplate = /<a href="(.+?)" target="_blank"><div class="messageLink">(.+?)<\/div><\/a>/im
		return msg.gsub(urlTemplate,"\\1").gsub(pageCardTemplate,"")
	end

	def parse
		msgTemplate = /<div class="chatLine" id="message_(\d+?)"><span class="picBox"><img class="profilePic" src=".+?"\/><\/span><span class="message"><span class="date" data-localtime-format>(.+?)<\/span><br \/><span class="userName( adminName)?">(.+?)<\/span>: (.+?)<\/span><\/div>/im
		results = @data.scan(msgTemplate)
		return results.map do |message|
			Message.new(message[0].to_i,clean_timestamp(message[1]),message[3],clean_message(message[4]))
		end
	end
end

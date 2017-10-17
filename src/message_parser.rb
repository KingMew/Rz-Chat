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

	def getMeMessages
		meTemplate = /<div class="chatLine" id="message_(\d+?)"><span class="picBox"><img class="profilePic" src="(?:\S*?)"\/><\/span><span class="message"><span class="date" data-localtime-format>(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})<\/span><br(?: \/)?><span style="font-style:italic; color: #444444">(.+?)<\/span><\/span><\/div>/im
		meResults = @data.scan(meTemplate)
		return meResults.map do |message|
			mesg_txt = "/me "+message[2].split(" ")[1..-1].join(" ")
			Message.new(message[0].to_i,clean_timestamp(message[1]),message[2].split(" ")[0],clean_message(mesg_txt))
		end
	end

	def getNormalMessages
		msgTemplate = /<div class="chatLine" id="message_(\d+?)"><span class="picBox"><img class="profilePic" src="(?:.*?)"\/><\/span><span class="message"><span class="date" data-localtime-format>(.*?)<\/span><br( \/)?><span class="userName( adminName)?">(.+?)<\/span>: (.+?)<\/span><\/div>/im
		results = @data.scan(msgTemplate)
		return (results.map do |message|
			Message.new(message[0].to_i,clean_timestamp(message[1]),message[4],clean_message(message[5]))
		end).concat(getMeMessages)
	end

	def parse
		messages = getNormalMessages().concat(getMeMessages)
		sorted = messages.sort_by do |obj| obj.id end
		return messages.sort do |obj,obj2| obj.id <=> obj2.id end
	end
end

require 'uri'
require 'cgi'
require 'net/http'
require_relative '../core/message_parser'

class RzWebChannelFetcher
	def initialize(sessionid,channelid=1)
		@sessionid = sessionid
		@channelid = channelid
		@cookie = CGI::Cookie.new("PHPSESSID",sessionid)
		@lastMessageId = 0
		@userlist = []
	end
	def get_userlist
		return @userlist
	end
	def channel_name
		if "#{@channelid}" == "1"
			"The Residents Chat"
		else
			"Chat Chat"
		end
	end
	def parse_userlist(body)
		regex = /<div id="userBox">(.+?)<\/div>/im
		@userlist = body.scan(regex)[0][0].split(',')
	end
	def fetch_heartbeat(lastMessageId)
		@lastMessageId = lastMessageId
		heartbeat_url = "http://residents.com/fans/chat/heartbeat.php"
		uri = URI(heartbeat_url)
		https = Net::HTTP.new(uri.host, uri.port)
		data = {
			"advert" => "false",
			"chatid" => "#{@channelid}",
			"lastMessageId" => @lastMessageId.to_s
		}
		request = Net::HTTP::Post.new(uri.request_uri)
		request.set_form_data(data)
		request['User-Agent'] = "Rz-Chat Terminal Client (https://github.com/meisekimiu/Rz-Chat)"
		request['Cookie'] = @cookie.to_s.sub(/; path=$/, '')
		body = ""
		begin
			response = https.request(request)
			body = response.body
			parse_userlist body
		ensure
			return body
		end
	end
	def send_message(msg_text)
		post_url = "http://residents.com/fans/chat/post.php"
		uri = URI(post_url)
		https = Net::HTTP.new(uri.host, uri.port)
		data = {
				"text" => msg_text,
				"chatId" => "#{@channelid}"
		}
		request = Net::HTTP::Post.new(uri.request_uri)
		request.set_form_data(data)
		request['User-Agent'] = "Rz-Chat Terminal Client (https://github.com/meisekimiu/Rz-Chat)"
		request['Cookie'] = @cookie.to_s.sub(/; path=$/, '')
		response = https.request(request)
	end
end

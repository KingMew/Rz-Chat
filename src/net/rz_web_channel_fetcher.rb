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
		request['User-Agent'] = "Mozilla/5.0 (X11; Linux x86_64; rv:56.0) Gecko/20100101 Firefox/56.0"
		request['Cookie'] = @cookie.to_s.sub(/; path=$/, '')
		response = https.request(request)
		body = response.body
		return body
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
		request['Cookie'] = @cookie.to_s.sub(/; path=$/, '')
		response = https.request(request)
	end
end

require 'ostruct'
require 'uri'
require 'net/http'

class RzWebLoginService
	def initialize(username,pw)
		@username = username
		@password = pw
	end

	def get_sessionid
		uri = URI("https://www.residents.com/fans/chat/chat.php")
		https = Net::HTTP.new(uri.host, uri.port)
		https.use_ssl = true
		sessionID = ""
		response = https.get(uri.path)
		if response.code != '200'
			raise "Can't connect to RZ Chat Page"
		else
			response.get_fields('Set-Cookie').each do |cookie|
				if cookie.include? "PHPSESSID"
					return cookie.split(";")[0].split("=")[1]
				end
			end
		end
		return false
	end

	def do_login
		sessionId = get_sessionid
		if sessionId == false
			raise "Can't get session id"
		end
		cookie = CGI::Cookie.new("PHPSESSID",sessionId)
		uri = URI("https://www.residents.com/fans/chat/login.php")
		https = Net::HTTP.new(uri.host, uri.port)
		data = {
			"username" => @username,
			"userpass" => @password
		}
		https.use_ssl = true
		request = Net::HTTP::Post.new(uri.request_uri)
		request.set_form_data(data)
		request['User-Agent'] = "Rz-Chat Terminal Client (https://github.com/meisekimiu/Rz-Chat)"
		request['Cookie'] = cookie.to_s.sub(/; path=$/, '')
		response = https.request(request)
		if response.code != '200'
			raise "Can't connect to RZ Chat Login"
		else
			if response.body == "successful login"
				return sessionId
			else
				p response.body
				return false
			end
		end
		return nil
	end

	def login
		sessionid = do_login
		if sessionid != false and sessionid != nil
			userdata = OpenStruct.new
			userdata.username = @username
			userdata.sessionid = sessionid
			userdata.password = @password
			userdata
		else
			false
		end
	end
end

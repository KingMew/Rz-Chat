require 'ostruct'
require 'uri'
require 'net/http'

class RzWebLoginService
	def initialize(username,pw)
		@username = username
		@password = pw
	end

	def do_login
		uri = URI("http://www.residents.com/fans/chat/login.php")
		https = Net::HTTP.new(uri.host, uri.port)
		data = {
			"username" => @username,
			"userpass" => @password
		}
		sessionID = ""
		response = https.post(uri.path,URI.encode_www_form(data))
		if response.code != '200'
			raise "Can't connect to RZ Chat Login"
		else
			if response.body == "successful login"
				sessionId = response.get_fields('Set-Cookie')[0].split(";")[0]
				return sessionId.split("=")[1]
			else
				p response
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

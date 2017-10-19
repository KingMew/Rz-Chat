require 'ostruct'

class MockLoginServer
	def initialize(username,pw)
		@username = username
		@password = pw
	end

	def login
		if @username == "mewee" && @password == "test"
			userdata = OpenStruct.new
			userdata.username = @username
			userdata.sessionid = "ayy lmao"
			userdata
		else
			false
		end
	end
end

require 'io/console'

class ConsoleLoginPrompt
	def initialize(serviceclass)
		@username = ""
		@password = ""
		@service = serviceclass
		@userdata = false
	end

	def get_userinfo
		print "Username: "
		@username = gets.strip
		print "Password: "
		@password = STDIN.noecho(&:gets).strip
		puts
	end

	def verify_userinfo
		service = @service.new(@username,@password)
		@userdata = service.login
	end

	def print_error
		sleep 3
		puts "Invalid username/password combination. Please try again."
		puts
		puts
	end

	def run
		puts "Residents.com Chat Client"
		puts
		loop do
			get_userinfo
			verify_userinfo
			break if @userdata != false
			print_error if @userdata == false
		end
		@userdata
	end
end

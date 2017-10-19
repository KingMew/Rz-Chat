#!/usr/bin/ruby
require_relative 'src/login/mock_login_server'
require_relative 'src/login/console_login_prompt'
require_relative 'src/ui/chat_ui'
require_relative 'src/conf/configuration_loader'
require_relative 'src/main'

loader = ConfigurationLoader.new
config = loader.load_config
userdata = nil
if config["username"] != nil && config["password"] != nil
	puts "User info already loaded"
	logintoken = MockLoginServer.new(config["username"],config["password"])
	userdata = logintoken.login
	if userdata == false
		puts "Error. Saved login data is incorrect. You'll need to manually log in."
		puts
		userdata = prompt_login
	end
	puts "Login success"
else
	userdata = prompt_login
end
ui = ChatUI.new(userdata)
ui.run

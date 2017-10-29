#!/usr/bin/ruby
require_relative 'src/net/rz_web_login_service'
require_relative 'src/login/console_login_prompt'
require_relative 'src/ui/chat_ui'
require_relative 'src/conf/configuration_loader'
require_relative 'src/main'

appstate = load_parameters
loader = ConfigurationLoader.new
if appstate.clear_conf
	loader.clear_config
end
config = loader.load_config
userdata = nil
if config["username"] != nil && config["password"] != nil && !appstate.manual_login
	puts "User info already loaded"
	logintoken = RzWebLoginService.new(config["username"],config["password"])
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
beepcmd = ""
beepcmd = config["beepcmd"] if config["beepcmd"] != nil
ui = ChatUI.new(userdata,beepcmd)
ui.run

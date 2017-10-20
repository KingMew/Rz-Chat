require_relative 'net/rz_web_login_service'
require_relative 'login/console_login_prompt'
require_relative 'ui/chat_ui'
require_relative 'conf/configuration_loader'

def prompt_login
	loader = ConfigurationLoader.new
	config = loader.load_config
	login_prompt = ConsoleLoginPrompt.new(RzWebLoginService)
	userdata = login_prompt.run
	config.add("username",userdata.username,true)
	config.add("password",userdata.password,true)
	print "Logged in! Type your username again to save your login data for next time: "
	user_signature = gets.strip
	if user_signature == userdata.username
		loader.save_config
	end
	return userdata
end

require_relative 'net/rz_web_login_service'
require_relative 'login/console_login_prompt'
require_relative 'ui/chat_ui'
require_relative 'conf/configuration_loader'
require_relative 'parameter_parser/ParameterParser'

def load_parameters
	manual_login = FlagParameter.new(:manual_login)
	manual_login.setDescription('forces a manual login even if auto-login data exists')
	manual_login.addIdentifier('--manual-login')
	clear_conf = FlagParameter.new(:clear_conf)
	clear_conf.setDescription('clears out all saved configuration when application starts')
	clear_conf.addIdentifier('--clear-config')
	parser = ParameterParser.new
	parser.add(manual_login)
	parser.add(clear_conf)
	parser.parse(ARGV)
end

def prompt_login
	loader = ConfigurationLoader.new
	config = loader.load_config
	login_prompt = ConsoleLoginPrompt.new(RzWebLoginService)
	userdata = login_prompt.run
	config.add("username",userdata.username,true)
	config.add("password",userdata.password,true)
	print "Logged in! Type your username again to save your login data for next time: "
	user_signature = STDIN.gets.strip
	if user_signature == userdata.username
		loader.save_config
	end
	return userdata
end

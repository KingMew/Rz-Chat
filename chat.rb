#!/usr/bin/ruby
require_relative 'src/login/mock_login_server'
require_relative 'src/login/console_login_prompt'
require_relative 'src/ui/chat_ui'

login_prompt = ConsoleLoginPrompt.new(MockLoginServer)
userdata = login_prompt.run
ui = ChatUI.new(userdata)
ui.run

#!/usr/bin/ruby
require_relative 'src/chat_ui'
require 'ostruct'

userdata = OpenStruct.new #We'll get userdata from a Login prompt later
userdata.username = 'mewee'
ui = ChatUI.new(userdata)
ui.run

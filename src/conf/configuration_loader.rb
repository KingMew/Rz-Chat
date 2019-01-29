require 'parseconfig'
require 'fileutils'

class ConfigurationLoader
	def initialize(environment=RUBY_PLATFORM)
		@env = environment
		@config = nil
	end

	def env_windows?
		(/cygwin|mswin|mingw|bccwin|wince|emx/ =~ @env) != nil
	end

	def locate_config
		if env_windows?
			"#{ENV['APPDATA']}"+'/RzChat/config'
		elsif ENV['XDG_CONFIG_HOME']
			"#{ENV['XDG_CONFIG_HOME']}"+'/RzChat/config'
		else
			"#{File.dirname(__FILE__)}/../../.config/config"
		end
	end

	def load_config
		path = File.expand_path(locate_config)
		unless File.exist?(path)
			FileUtils.mkdir_p(File.dirname(path))
			FileUtils.touch(path)
		end
		@config = ParseConfig.new(path)
		return @config
	end

	def save_config
		path = File.expand_path(locate_config)
		unless File.exist?(path)
			FileUtils.mkdir_p(File.dirname(path))
			FileUtils.touch(path)
		end
		file = File.open(path,'w')
		@config.write(file)
		file.close
	end

	def clear_config
		path = File.expand_path(locate_config)
		if File.exist?(path)
			FileUtils.rm(path)
		end
	end
end

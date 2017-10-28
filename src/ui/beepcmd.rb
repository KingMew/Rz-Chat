class BeepCmd
	def initialize(command)
		@command = command
	end

	def create_silent_command(cmd)
		#XXX: This should be portable and work on Windows too
		cmd+" >/dev/null 2>&1"
	end

	def execute
		pid = spawn(create_silent_command(@command))
		Process.detach(pid)
	end
end

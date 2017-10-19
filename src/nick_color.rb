class NickColor
	def initialize(username)
		@username = username.downcase
	end

	def generateColor
		available_colors = [1,2,3,4,8,9,10,11,12,13,14,15]
		sum = 0
		@username.each_char do |c|
			sum += c.ord
		end
		return available_colors[sum % available_colors.length]
	end

	def getColor
		if @username == "mewee"
			5
		elsif @username == "goatie" || @username == "bb" || @username == "hardyfox"
			6
		elsif @username.slice(-8,8) == "(lurker)"
			-1
		else
			generateColor
		end
	end
end

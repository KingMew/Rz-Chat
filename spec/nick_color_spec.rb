require_relative '../src/ui/nick_color'

describe NickColor do
	before :each do
		@nicks = Hash.new
		@nicks["mewee"] = NickColor.new("mewee")
		@nicks["goatie"] = NickColor.new("goatie")
		@nicks["bb"] = NickColor.new("BB")
		@nicks["hardyfox"] = NickColor.new("hardyfox")
		@nicks["test"] = NickColor.new("test")
		@nicks["lurker"] = NickColor.new("test2 (lurker)")
	end
	describe '.getColor' do
		it 'should return color' do
			expect(@nicks["mewee"].getColor).to eq 5
			expect(@nicks["goatie"].getColor & @nicks["hardyfox"].getColor &
				@nicks["bb"].getColor).to eq 6
			expect(@nicks["test"].getColor).to eq 8
			expect(@nicks["lurker"].getColor).to eq -1
		end
	end
end

require_relative '../src/core/message_parser'

describe MessageParser do
	before :each do
		@parser = MessageParser.new ( File.open(File.expand_path(File.dirname(__FILE__))+"/mockdata/chat_sample.txt", "rb").read )
	end
	describe '.parse' do
		it "should get message text" do
			messages = @parser.parse
			expect(messages[0].message).to eq "https://bobuck.bandcamp.com/album/left-with-the-fires"
			expect(messages[2].message).to eq "Oh boy, a NEW Residents newsletter from Cherry Red"
		end
		it "should get nicks correctly" do
			messages = @parser.parse
			expect(messages[0].author).to eq "snorp"
			expect(messages[2].author).to eq "mewee"
		end
		it "should parse emojis correctly" do
			messages = @parser.parse
			expect(messages[8].message).to eq ":mrwonderfulscream:"
		end
		it "should get time correctly" do
			messages = @parser.parse
			expect(messages[0].time[2..7]).to eq ":35:37"
			#This test will return different hours depending on local machine time.
			#Hopefully you're not in one of those freaky half hour timezones
		end
		it "should get message ID" do
			messages = @parser.parse
			expect(messages[0].id).to eq 214981
		end
		it "should parse /me text" do
			messages = @parser.parse
			expect(messages[9].message).to eq "/me remembers Pepperidge Farm"
		end
		it "should parse out newlines" do
			messages = @parser.parse
			expect(messages[10].message).to eq "test / test test / test!!!"
		end
	end
end

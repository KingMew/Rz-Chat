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
			expect(messages[0].time).to eq "08:35:37"
		end
		it "should get message ID" do
			messages = @parser.parse
			expect(messages[0].id).to eq 214981
		end
		it "should parse /me text" do
			messages = @parser.parse
			expect(messages[9].message).to eq "/me remembers Pepperidge Farm"
		end
	end
end

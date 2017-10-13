require_relative '../src/message_parser'

describe MessageParser do
	describe '.new' do
		it "is creatable" do
			MessageParser.new
		end
	end
end

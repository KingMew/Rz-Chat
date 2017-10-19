require_relative '../src/message_formatter'
require 'ostruct'

describe MessageFormatter do
	before :each do
		@msg = OpenStruct.new
		@msg.author = "mewee"
		@msg.time = "2017-10-13 12:13:53"
		@msg.id = 1
		@formatter = MessageFormatter.new(40)
	end
	describe 'format' do
		it 'should format short message' do
			@msg.message = "ayy lmao"
			pieces = @formatter.format(@msg)
			expect(pieces[0]).to eq "ayy lmao"
		end
		it 'should format long message' do
			@msg.message = "123456789012345678901234567890"
			pieces = @formatter.format(@msg)
			expect(pieces[0].strip).to eq "123456789012"
			expect(pieces[1].strip).to eq "345678901234"
		end
	end
end

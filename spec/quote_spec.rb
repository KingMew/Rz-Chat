require_relative '../src/core/rz_quotes'

describe RzQuote do
	before :each do
		@quote = RzQuote.new
	end

	describe '.get_all_quotes' do
		it 'should get array of definitions' do
			expect(@quote.get_all_quotes).to_not be_empty
		end
		it 'should have "Clifford Mode"' do
			all_quotes = @quote.get_all_quotes
			clifford_quotes = @quote.get_all_quotes(true)
			expect(all_quotes.size).to be > clifford_quotes.size
		end
	end

	describe '.quote' do
		it 'should get a quote' do
			expect(@quote.quote(true)).to be_a(String)
		end
		it 'should have "Clifford Mode"' do
			expect(@quote.get_all_quotes(true).include?(@quote.quote(true))).to be_truthy
		end
	end
end

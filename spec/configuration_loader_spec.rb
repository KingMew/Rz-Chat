require_relative '../src/conf/configuration_loader'

describe ConfigurationLoader do
	describe '.new' do
		it 'should be creatable' do
			ConfigurationLoader.new
		end
	end
	#Can't really do any other tests due to the fact that it mainly just does
	#filesystem reading and writing.
	#
	#I mean... I could mock the filesystem, but that's going a bit overboard.
end

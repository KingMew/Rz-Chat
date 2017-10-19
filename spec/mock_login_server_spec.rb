require_relative '../src/login/mock_login_server'

describe MockLoginServer do
	describe '.login' do
		it 'should be able to log in' do
			valid = MockLoginServer.new("mewee","test")
			expect(valid.login).not_to be_falsey
		end
		it 'should be able to return false if there is a login error' do
			invalid = MockLoginServer.new("mewee","invalid password")
			expect(invalid.login).to be_falsey
		end
	end
end

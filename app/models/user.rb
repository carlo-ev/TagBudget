class User < ActiveRecord::Base
	include History
	has_secure_password
	has_many :transactions
end

class User < ActiveRecord::Base
	validates :email, uniqueness: {case_sensitive: true}
	include History
	has_secure_password
	has_many :transactions
end

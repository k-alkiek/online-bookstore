class User < ApplicationRecord
	self.table_name = "User"

	def authenticate(password_digest)
		BCrypt::Password.new(self[:password]) == password_digest
	end


end

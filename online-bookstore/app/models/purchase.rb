class Purchase < ApplicationRecord
	self.table_name = "PURCHASE"
  belongs_to :User
end

class BookAuthor < ApplicationRecord
	self.table_name = "BOOK_AUTHOR"
  belongs_to :AUTHOR
end

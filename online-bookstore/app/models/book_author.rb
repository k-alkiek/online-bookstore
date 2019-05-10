class BookAuthor < ApplicationRecord
	self.table_name = "BOOK_AUTHOR"
	belongs_to :book, primary_key: :ISBN, foreign_key: :BOOK_ISBN
end

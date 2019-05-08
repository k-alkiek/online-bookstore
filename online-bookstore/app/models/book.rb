class Book < ApplicationRecord
	self.table_name = "BOOK"
	has_many :book_authors, foreign_key: "BOOK_ISBN"
	accepts_nested_attributes_for :book_authors, allow_destroy: true
end

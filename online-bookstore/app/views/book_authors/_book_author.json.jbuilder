json.extract! book_author, :id, :BOOK_ISBN, :AUTHOR_id, :created_at, :updated_at
json.url book_author_url(book_author, format: :json)

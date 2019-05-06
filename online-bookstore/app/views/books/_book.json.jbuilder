json.extract! book, :id, :title, :category, :selling_price, :Minimum_threshold, :Available_copies_count, :PUBLISHER_Name, :publish_year, :created_at, :updated_at
json.url book_url(book, format: :json)

json.extract! order, :id, :date_submitted, :estimated_arrival_date, :confirmed, :BOOK_ISBN, :quantity, :created_at, :updated_at
json.url order_url(order, format: :json)

json.extract! purchase, :id, :User_id, :BOOK_ISBN, :No_of_copies, :price, :date_of_purchase, :created_at, :updated_at
json.url purchase_url(purchase, format: :json)

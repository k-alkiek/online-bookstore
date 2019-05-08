# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

categories = ["Science", "Art", "Religion", "History", "Geography"]

puts "***** Creating Users *****"
admin = User.find_or_create_by(email: 'admin@store.com', password: BCrypt::Password.create('12345678'), first_name: 'admin', last_name: 'admin', phone: Faker::PhoneNumber.phone_number, address: Faker::Address.street_address, isManager: true, date_joined: Date.today)
user1 = User.find_or_create_by(email: 'user1@store.com', password: BCrypt::Password.create('12345678'), first_name: 'user1', last_name: 'user1', phone: Faker::PhoneNumber.phone_number, address: Faker::Address.street_address, isManager: false, date_joined: Date.today)
user2 = User.find_or_create_by(email: 'user2@store.com', password: BCrypt::Password.create('12345678'), first_name: 'user2', last_name: 'user2', phone: Faker::PhoneNumber.phone_number, address: Faker::Address.street_address, isManager: false, date_joined: Date.today)
user3 = User.find_or_create_by(email: 'user3@store.com', password: BCrypt::Password.create('12345678'), first_name: 'user3', last_name: 'user3', phone: Faker::PhoneNumber.phone_number, address: Faker::Address.street_address, isManager: false, date_joined: Date.today)

puts "***** Creating Authors *****"
authors = 50.times.to_a
authors.map! do
	Author.create(Author_name: Faker::FunnyName.name)
end


puts "***** Creating Publishers *****"
publishers = 50.times.to_a
publishers.map! do
	Publisher.create(Name: Faker::Company.unique.name, address: Faker::Address.street_address, telephone: Faker::PhoneNumber.phone_number)
end


puts "***** Creating Books *****"
prices = (20..100).step(5).to_a
thresholds = (10..100).step(5).to_a
above_threshold = (1..10).to_a

books = 250.times.to_a
books.map! do
	threshold = thresholds.sample
	available = threshold + above_threshold.sample
	Book.create(ISBN: Faker::Code.unique.isbn,
		title: Faker::Book.title,
		category: categories.sample,
		selling_price: prices.sample,
		Minimum_threshold: threshold,
		Available_copies_count: available,
		PUBLISHER_Name: publishers.sample.Name,
		publish_year: Faker::Date.birthday(5, 65)
	)
end

puts "***** Creating Book Authors *****"
authors_count = (1..3).to_a

books.each do |book|
	authors_count.sample.times do
		BookAuthor.find_or_create_by(BOOK_ISBN: book.ISBN, AUTHOR_id: authors.sample.id)
	end
end
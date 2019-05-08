class CartController < ApplicationController
	include SessionsHelper
	before_action :set_cart_books, only: [:show, :add_to_cart, :delete, :edit]
  
  def show
 	#user = SessionHelper.current_user
 	p = ActiveRecord::Base.establish_connection
 	c = p.connection
  	@result = []
  	@cart_books = @cart_books.map{|e| "\"#{e}\"" }
  	str = @cart_books.join(",")
  	if !str.empty?
		@result = c.execute("select ISBN,title,category,selling_price,Available_copies_count,PUBLISHER_Name,publish_year from BOOK where ISBN IN (#{str})")
 	end
  end

  def add_to_cart
  	if !@cart_books.include? params[:ISBN]
  		@cart_books.push params[:ISBN]
  		@book_quantity.push params[:quantity]
  	end    
    cart_books_str = @cart_books.join(",")	
    book_quantity_str = @book_quantity.join(",")
    cookies.permanent[:books_in_cart] = cart_books_str
    cookies.permanent[:quantity_ordered] = book_quantity_str
    redirect_to action: 'show'
  end

  def edit
  	index = @cart_books.index(params[:ISBN])
  	@book_quantity[index] = params[:newquantity]
  	book_quantity_str = @book_quantity.join(",")
  	cookies.permanent[:quantity_ordered] = book_quantity_str
  	redirect_to action: 'show'
  end

  def delete
  	index = @cart_books.index(params[:ISBN])
  	@cart_books.delete_at(index)
  	@book_quantity.delete_at(index)
  	cart_books_str = @cart_books.join(",")
  	book_quantity_str = @book_quantity.join(",")
    cookies.permanent[:books_in_cart] = cart_books_str
    cookies.permanent[:quantity_ordered] = book_quantity_str
    redirect_to action: 'show'
  end

  private
  def set_cart_books
  	@cart_books = cookies[:books_in_cart] ? cookies[:books_in_cart].split(",") : []
  	@book_quantity = cookies[:quantity_ordered] ? cookies[:quantity_ordered].split(",") : []
  end
end

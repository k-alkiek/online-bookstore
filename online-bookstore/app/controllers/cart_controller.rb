class CartController < ApplicationController
	include SessionsHelper
	before_action :set_cart_books, only: [:show, :add_to_cart]
  def show
 	#user = SessionHelper.current_user
 	p = ActiveRecord::Base.establish_connection
 	c = p.connection
  	@rows = []
	@cart_books.each do |book|
		result = c.execute("select * from BOOK where ISBN =  \"#{book}\"")
		@rows.push result.first
	end
  end

  def add_to_cart
    @cart_books.push params[:ISBN]
    @cart_books_arr = @cart_books.join(",")
    @quantity += 1
    cookies.permanent.signed[:no_of_books] = @quantity
    cookies.permanent[:books_in_cart] = @cart_books_arr
    redirect_to action: 'show'
  end

  private
  def set_cart_books
  	@cart_books = cookies[:books_in_cart] ? cookies[:books_in_cart].split(",") : []
  	@quantity = cookies[:no_of_books] ? cookies[:no_of_books] : 0
  end
end

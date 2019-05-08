class CartController < ApplicationController
	include SessionsHelper
	before_action :set_cart_books, only: [:show, :add_to_cart]
  
  def show
 	#user = SessionHelper.current_user
 	p = ActiveRecord::Base.establish_connection
 	c = p.connection
  	@rows = []
  	@cart_books = @cart_books.map{|e| "\"#{e}\"" }
  	binding.pry
  	str = @cart_books.join(",")
	@result = c.execute("select ISBN,title,category,selling_price,Available_copies_count,PUBLISHER_Name,publish_year from BOOK where ISBN IN (#{str})")
  end

  def add_to_cart
  	if !@cart_books.include? params[:ISBN]
  		@cart_books.push params[:ISBN]
  	end    
    cart_books_str = @cart_books.join(",")
    cookies.permanent[:books_in_cart] = cart_books_str
    redirect_to action: 'show'
  end

  def edit
  	
  end

  def delete
  	
  end
  private
  def set_cart_books
  	@cart_books = cookies[:books_in_cart] ? cookies[:books_in_cart].split(",") : []
  end
end

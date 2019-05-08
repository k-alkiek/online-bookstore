class BooksController < ApplicationController
  protect_from_forgery
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  before_action :check_logged_in, only: [:create, :new, :update, :destroy]
  before_action :set_publishers, only: [:edit, :new, :create,:update,:index]


  # GET /books
  # GET /books.json
  def index
    add_filters
    @books = if params[:isbn].nil?
      Book.search(params[:name], @filters)
    else
      Book.isbn_search(params[:isbn])
             end
  end

  # GET /books/1
  # GET /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(book_params)
    respond_to do |format|
      begin
        sql = "INSERT INTO BOOK
        VALUES (\"#{params[:book][:ISBN]}\" ,
                \"#{params[:book][:title]}\" ,
                \"#{params[:book][:category]}\" ,
                #{params[:book][:selling_price]} ,
                #{params[:book][:Minimum_threshold]} ,
                #{params[:book][:Available_copies_count]} ,
                \"#{params[:book][:PUBLISHER_Name]}\",
                \"#{params[:book]["publish_year(1i)"]}-#{params[:book]["publish_year(2i)"].rjust(2, '0')}-#{params[:book]["publish_year(3i)"].rjust(2, '0')}\")"
        ActiveRecord::Base.connection.execute(sql)

        format.html { redirect_to books_url, notice: 'Book was successfully created.'}
        format.json { render :show, status: :created, location: books_path }
      rescue
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      begin
        sql = "UPDATE BOOK SET
        ISBN = \"#{params[:book][:ISBN]}\"
        ,title = \"#{params[:book][:title]}\"
        ,category = \"#{params[:book][:category]}\"
        ,selling_price = #{params[:book][:selling_price]}
        ,Minimum_threshold = #{params[:book][:Minimum_threshold]}
        ,Available_copies_count = #{params[:book][:Available_copies_count]}
        ,PUBLISHER_name = \"#{params[:book][:PUBLISHER_Name]}\"
        ,publish_year = \"#{params[:book]["publish_year(1i)"]}-#{params[:book]["publish_year(2i)"].rjust(2, '0')}-#{params[:book]["publish_year(3i)"].rjust(2, '0')}\"
         where ISBN = \"#{params[:id]}\""
        ActiveRecord::Base.connection.execute(sql)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      rescue
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    sql = "Delete FROM BOOK Where ISBN = \"#{params[:id]}\""
    ActiveRecord::Base.connection.execute(sql)

    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_book
    @book = Book.find_by_sql("SELECT * FROM BOOK WHERE ISBN = \"#{params[:id]}\"")[0]
  end


  # Never trust parameters from the scary internet, only allow the white list through.
  def book_params
    params.require(:book).permit(:ISBN, :title, :category, :selling_price, :Minimum_threshold, :Available_copies_count, :PUBLISHER_Name, :publish_year)
  end

  def set_publishers
    @publishers = Publisher.all
  end

  def add_filters
    @filters = []
    if @search_with_publishers

    end

    if @search_with_authors

    end

    if @search_with_price_range

    end

    if @search_with_categories

    end

    if @search_with_publication_year

    end

  end

end

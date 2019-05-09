class BooksController < ApplicationController
  protect_from_forgery
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  before_action :check_logged_in
  before_action :set_publishers, only: [:edit, :new, :create,:update,:index]
  before_action :set_authors, only: [:edit, :new, :update, :create]

  # GET /books
  # GET /books.json
  def index
    set_books
  end

  # GET /books/1
  # GET /books/1.json
  def show
    sql = "SELECT id, Author_name FROM AUTHOR JOIN BOOK_AUTHOR ON id = AUTHOR_id WHERE BOOK_ISBN = \"#{@book.id}\""
    @book_authors = Author.find_by_sql(sql)
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

        authors = []
        params[:book][:book_authors_attributes].each { |k, h| authors.push(h["AUTHOR_id"]) }
        delete_book_authors_sql = "DELETE FROM BOOK_AUTHOR WHERE BOOK_ISBN = \"#{params[:book][:ISBN]}\""
        insert_book_author_sql = "INSERT INTO BOOK_AUTHOR VALUES (\"#{params[:book][:ISBN]}\", \"%d\")"
        ActiveRecord::Base.connection.execute(delete_book_authors_sql)
        authors.each { |a|  ActiveRecord::Base.connection.execute(insert_book_author_sql % a) }

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
    respond_to do |format|
      begin
        sql = "Delete FROM BOOK Where ISBN = \"#{params[:id]}\""
        ActiveRecord::Base.connection.execute(sql)
        set_books
        format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
        format.json { head :no_content }
      rescue
        set_books
        format.html { redirect_to books_url, notice: 'Book was\'t destroyed.' }
        format.json { head :no_content }
      end
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
    @publishers = Publisher.find_by_sql("SELECT * FROM PUBLISHER ORDER BY Name ASC")
  end

  def set_authors
    @authors = Author.find_by_sql("SELECT * FROM AUTHOR ORDER BY Author_name ASC")
  end

  def add_filters

    @filters = []
    @name = if params[:name].present?
              params[:name]
            else
              nil
            end

    if params[:author].present?
      authors_ids = ActiveRecord::Base.connection.execute("SELECT id FROM AUTHOR where lower(Author_name) like \"%#{params[:author].to_s.downcase}%\"").map {|e| e = e[0]}
      books_isbn = ActiveRecord::Base.connection.execute("SELECT Distinct BOOK_ISBN FROM BOOK_AUTHOR WHERE AUTHOR_id IN (#{authors_ids.join(", ")})").map {|e| e = e[0]}
      @filters.push(" ISBN IN (\"#{books_isbn.join("\", \"")}\")")
    end

    if params[:publisher].present?
      @filters.push(" lower(PUBLISHER_Name) like \"%'#{params[:publisher].to_s.downcase}'%\"")
    end

    if params[:category].present?
      @filters.push(" category ='#{params[:category]}'")
    end

    if params[:publish_date].present?
      @filters.push(" publish_year LIKE '%#{params[:publish_date]}-__-__'")
    end

    if params[:price_from].present?
      @filters.push(" selling_price >= #{params[:price_from]}")
    end

    if params[:price_to].present?
      @filters.push(" selling_price <= #{params[:price_to]}")
    end

  end

  def set_books
    add_filters
    @books = if params[:isbn].nil?
               Book.search(params[:name], @filters)
             else
               Book.isbn_search(params[:isbn])
             end
    @books = @books.paginate(:page => params[:page] || 1,:per_page => 50)
    @filters = nil
  end

end

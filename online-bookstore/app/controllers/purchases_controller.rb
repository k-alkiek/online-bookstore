class PurchasesController < ApplicationController
  load_and_authorize_resource
  
  before_action :set_purchase, only: [:show]
  before_action :check_logged_in

  # GET /purchases
  # GET /purchases.json
  def index
    if current_user.isManager
      @purchases = Purchase.find_by_sql("SELECT * FROM PURCHASE").paginate(:page => params[:page] || 1,:per_page => 50)
    else
      @purchases = Purchase.find_by_sql("SELECT * FROM PURCHASE Where User_id = #{current_user.id.to_i} ").paginate(:page => params[:page] || 1,:per_page => 50)
    end
  end

  # GET /purchases/1
  # GET /purchases/1.json
  def show
  end

  # GET /purchases/new
  def new
    @purchase = Purchase.new
  end

  # GET /purchases/1/edit
  def edit
  end

  # POST /purchases
  # POST /purchases.json
  def create
    @purchase = Purchase.new(purchase_params)

    respond_to do |format|
      if @purchase.save
        format.html { redirect_to @purchase, notice: 'Purchase was successfully created.' }
        format.json { render :show, status: :created, location: @purchase }
      else
        format.html { render :new }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /purchases/1
  # PATCH/PUT /purchases/1.json
  def update
    respond_to do |format|
      if @purchase.update(purchase_params)
        format.html { redirect_to @purchase, notice: 'Purchase was successfully updated.' }
        format.json { render :show, status: :ok, location: @purchase }
      else
        format.html { render :edit }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /purchases/1
  # DELETE /purchases/1.json
  def destroy
    @purchase.destroy
    respond_to do |format|
      format.html { redirect_to purchases_url, notice: 'Purchase was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
 
  def checkout
  end

  def confirm_checkout
    p = ActiveRecord::Base.establish_connection
    c = p.connection
    result = []
    cart_books = cookies[:books_in_cart] ? cookies[:books_in_cart].split(",") : []
    cart_books = cart_books.map{|e| "\"#{e}\"" }
    str = cart_books.join(",")
    if !str.empty?
    result = c.execute("select selling_price from BOOK where ISBN IN (#{str})")
    end
    book_quantity = cookies[:quantity_ordered] ? cookies[:quantity_ordered].split(",") : []
    query = ""
    @error = false;
    cart_books.zip(book_quantity).each do |book, quantity|
      query << "update BOOK set Available_copies_count = Available_copies_count - #{quantity} where ISBN = \\\"#{book}\\\";\n"
    end
    binding.pry
    a.zip(b).map{|x, y| x * y}
          query << "insert into PURCHASE values (#{user.id}, \\\"#{book}\\\", #{quantity}, , curDate());\\\n"

    result = call_procedure(query)
    if !(result == 'Purchase completed successfully.')
      flash[:danger] = result
      redirect_to cart_show_path
    else
      cookies.delete(:books_in_cart)
      cookies.delete(:quantity_ordered)
      redirect_to books_path, notice: result
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_purchase
      @purchase = Purchase.find_by_sql("SELECT * FROM PURCHASE WHERE id = #{params[:id].to_i}")[0]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def purchase_params
      params.require(:purchase).permit(:User_id, :BOOK_ISBN, :No_of_copies, :price, :date_of_purchase)
    end

    def call_procedure(query)
      result = ActiveRecord::Base.connection.execute("call make_purchase(\"#{query}\");")
      return result.first.first
    end
end

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
    detector = CreditCardValidations::Detector.new(params[:credit_card_no])
    unless detector.valid?
      flash[:error] = 'Invalid credit card credentials'
      redirect_to checkout_purchases_path
      return
    end

    cart_books = cookies[:books_in_cart] ? cookies[:books_in_cart] : ""
    book_quantity = cookies[:quantity_ordered] ? cookies[:quantity_ordered] : ""
    @error = false;
    result = call_procedure(cart_books, book_quantity, current_user.id)
    if !(result == 'Purchase completed successfully.')
      flash[:danger] = result
      redirect_to cart_show_path
    else
      cookies.delete(:books_in_cart)
      cookies.delete(:quantity_ordered)
      redirect_to books_path, notice: "#{result}\nCredit card vendor: #{detector.brand}"
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

    def call_procedure(isbn_list, quantity_list, user_id)
      result = ActiveRecord::Base.connection.execute("call insert_purchases(\"#{isbn_list}\", \"#{quantity_list}\", #{user_id});")
      return result.first.first
    end
end

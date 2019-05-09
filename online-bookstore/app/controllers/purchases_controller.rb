class PurchasesController < ApplicationController
  before_action :set_purchase, only: [:show, :edit, :update, :destroy]

  # GET /purchases
  # GET /purchases.json
  def index
    @purchases = Purchase.all
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
    puts @number
    puts @date
    cart_books = cookies[:books_in_cart] ? cookies[:books_in_cart].split(",") : []
    book_quantity = cookies[:quantity_ordered] ? cookies[:quantity_ordered].split(",") : []
    query = ""
    @error = false;
    cart_books.zip(book_quantity).each do |book, quantity|
      query << "update BOOK set Available_copies_count = Available_copies_count - #{quantity} where ISBN = \\\"#{book}\\\";\n"
    end
    result = call_procedure(query)
    if !(result == 'Purchase completed successfully.')
      flash[:danger] = result
    else
      flash[:notice] = result
      cookies.delete(:books_in_cart)
      cookies.delete(:quantity_ordered)
    end
    render "checkout"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_purchase
      @purchase = Purchase.find(params[:id])
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

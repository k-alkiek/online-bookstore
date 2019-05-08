class PurchasesController < ApplicationController
  before_action :set_purchase, only: [:show, :edit, :update, :destroy]
  before_action :check_logged_in

  # GET /purchases
  # GET /purchases.json
  def index
    @purchases = Purchase.find_by_sql("SELECT * FROM PURCHASE")
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
      begin
        sql = "INSERT INTO PURCHASE
       ( USER_id , BOOK_ISBN, No_of_copies, date_of_purchase)
        VALUES ( #{params[:purchase][:User_id]},
        \"#{params[:purchase][:BOOK_ISBN]}\", #{params[:purchase][:No_of_copies].to_i}
          , curdate() )"
        ActiveRecord::Base.connection.execute(sql)
        @purchases = Purchase.find_by_sql("SELECT * FROM PURCHASE")
        format.html { redirect_to purchases_url, notice: 'Purchase was successfully created.' }
        format.json { render :show, status: :created, location: @purchase }
      rescue
        format.html { render :new }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /purchases/1
  # PATCH/PUT /purchases/1.json
  def update
    respond_to do |format|
      begin
        sql = "UPDATE PURCHASE SET
        No_of_copies = #{params[:purchase][:No_of_copies]}
        ,date_of_purchase = \"#{params[:purchase][:date_of_purchase]}\"
         where id = #{params[:id].to_i}"
        ActiveRecord::Base.connection.execute(sql)
        format.html { redirect_to @purchase, notice: 'Purchase was successfully updated.' }
        format.json { render :show, status: :ok, location: @purchase }
      rescue
        format.html { render :edit }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }

      end
    end
  end

  # DELETE /purchases/1
  # DELETE /purchases/1.json
  def destroy
    sql = "Delete FROM PURCHASE WHERE id = #{params[:id].to_i}"
    ActiveRecord::Base.connection.execute(sql)
    respond_to do |format|
      format.html { redirect_to purchases_url, notice: 'Purchase was successfully destroyed.' }
      format.json { head :no_content }
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
end

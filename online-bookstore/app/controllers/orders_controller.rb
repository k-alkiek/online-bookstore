class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy,:confirm]
  before_action :check_logged_in
  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.find_by_sql("SELECT * FROM `ORDER`")
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)

    respond_to do |format|

      begin

        sql = "INSERT INTO `ORDER`
       ( date_submitted , BOOK_ISBN, quantity)
        VALUES ( curdate(),
        \"#{params[:order][:BOOK_ISBN]}\", #{params[:order][:quantity].to_i})"
        ActiveRecord::Base.connection.execute(sql)
        @orders = Order.find_by_sql("SELECT * FROM `ORDER`")
        format.html { redirect_to orders_url, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      rescue
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      begin
        sql = "UPDATE `ORDER` SET
        estimated_arrival_date = \"#{params[:user][:estimated_arrival_date]}\"
        ,confirmed = \"#{params[:user][:confirmed]}\"
        ,BOOK_ISBN = \"#{params[:user][:BOOK_ISBN]}\"
        ,address = \"#{params[:user][:quantity]}\" where id = #{params[:id].to_i}"
        ActiveRecord::Base.connection.execute(sql)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      rescue
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }

      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    sql = "Delete FROM `ORDER` Where id = #{params[:id].to_i}"
    ActiveRecord::Base.connection.execute(sql)
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end



  def confirm
    sql = "UPDATE `ORDER` SET confirmed = TRUE where id = #{params[:id] }"
    ActiveRecord::Base.connection.execute(sql)
    redirect_to orders_url
  end

  def unconfirm
    sql = "UPDATE `ORDER` SET confirmed = FALSE where id = #{params[:id] }"
    ActiveRecord::Base.connection.execute(sql)
    redirect_to orders_url
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find_by_sql("SELECT * FROM `ORDER` Where id = #{params[:id].to_i}")[0]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:date_submitted, :estimated_arrival_date, :confirmed, :BOOK_ISBN, :quantity)
    end
end

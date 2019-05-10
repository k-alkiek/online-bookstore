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

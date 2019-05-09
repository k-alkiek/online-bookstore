class PublishersController < ApplicationController
  before_action :set_publisher, only: [:show, :edit, :update, :destroy]
  before_action :check_logged_in

  # GET /publishers
  # GET /publishers.json
  def index
    @publishers = Publisher.find_by_sql("SELECT * FROM PUBLISHER").paginate(:page => params[:page] || 1,:per_page => 20)
  end

  # GET /publishers/1
  # GET /publishers/1.json
  def show
  end

  # GET /publishers/new
  def new
    @publisher = Publisher.new
  end

  # GET /publishers/1/edit
  def edit
  end

  # POST /publishers
  # POST /publishers.json
  def create
    @publisher = Publisher.new(publisher_params)

    respond_to do |format|
      begin
        sql = "INSERT INTO PUBLISHER
       ( Name , address , telephone )
        VALUES (\"#{params[:publisher][:Name]}\" ,
                 \"#{params[:publisher][:address]}\",
                \"#{params[:publisher][:telephone]}\")"
        ActiveRecord::Base.connection.execute(sql)
        @publishers = Publisher.find_by_sql("SELECT * FROM PUBLISHER")
        format.html { redirect_to publishers_url, notice: 'Publisher was successfully created.' }
        format.json { render :show, status: :created, location: @publisher }
      rescue

        format.html { render :new }
        format.json { render json: @publisher.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /publishers/1
  # PATCH/PUT /publishers/1.json
  def update
    respond_to do |format|
      begin
        sql = "UPDATE PUBLISHER SET
        Name = \"#{params[:publisher][:Name]}\"
        ,address = \"#{params[:publisher][:address]}\"
        ,telephone = \"#{params[:publisher][:telephone]}\"
         where Name = \"#{params[:id]}\""
        ActiveRecord::Base.connection.execute(sql)
        format.html { redirect_to @publisher, notice: 'Publisher was successfully updated.' }
        format.json { render :show, status: :ok, location: @publisher }
      rescue

        format.html { render :edit }
        format.json { render json: @publisher.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /publishers/1
  # DELETE /publishers/1.json
  def destroy
    begin
      sql = "Delete FROM PUBLISHER Where Name = '#{params[:id]}'"
      ActiveRecord::Base.connection.execute(sql)
      @publishers = Publisher.find_by_sql("SELECT * FROM PUBLISHER").paginate(:page => params[:page] || 1,:per_page => 20)
      respond_to do |format|
        format.html { redirect_to publishers_url, notice: 'Publisher was successfully destroyed.'}
        format.json { head :no_content }
      end
    rescue
      @publishers = Publisher.find_by_sql("SELECT * FROM PUBLISHER").paginate(:page => params[:page] || 1,:per_page => 20)
      respond_to do |format|
        format.html { redirect_to publishers_url, notice: 'Publisher was\'t destroyed.' }
        format.json { head :no_content }
      end
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_publisher
      @publisher = Publisher.find_by_sql("SELECT * FROM PUBLISHER Where Name = \"#{params[:id]}\"")[0]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def publisher_params
      params.require(:publisher).permit(:Name, :address, :telephone)
    end
end

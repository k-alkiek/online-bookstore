class AuthorsController < ApplicationController
  load_and_authorize_resource
  
  before_action :set_author, only: [:show, :edit, :update, :destroy]
  before_action :check_logged_in

  # GET /authors
  # GET /authors.json
  def index
    @authors = Author.find_by_sql("SELECT * FROM AUTHOR").paginate(:page => params[:page] || 1,:per_page => 20)
  end

  # GET /authors/1
  # GET /authors/1.json
  def show
  end

  # GET /authors/new
  def new
    @author = Author.new
  end

  # GET /authors/1/edit
  def edit
  end

  # POST /authors
  # POST /authors.json
  def create
    @author = Author.new(author_params)
    respond_to do |format|
      begin
        sql = "INSERT INTO AUTHOR
         ( Author_name )
          VALUES (\"#{params[:author][:Author_name]}\")"
        ActiveRecord::Base.connection.execute(sql)
        @authors = Author.find_by_sql("SELECT * FROM AUTHOR")
        format.html { redirect_to authors_path, notice: 'Author was successfully created.' }
        format.json { render :show, status: :created, location: @author }
      rescue => error
        flash.now[:alert] =  error.message
        format.html { render :new }
        format.json { render json: @author.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /authors/1
  # PATCH/PUT /authors/1.json
  def update
    respond_to do |format|

      begin
        sql = "UPDATE AUTHOR SET
         Author_name = (\"#{params[:author][:Author_name]}\")"
        ActiveRecord::Base.connection.execute(sql)
        @authors = Author.find_by_sql("SELECT * FROM AUTHOR")
        format.html { redirect_to authors_path, notice: 'Author was successfully updated.' }
        format.json { render :show, status: :created, location: @author }
      rescue => error
        flash.now[:alert] =  error.message
        format.html { render :edit }
        format.json { render json: @author.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /authors/1
  # DELETE /authors/1.json

  def destroy
    respond_to do |format|
      begin
        sql = "Delete FROM AUTHOR Where id = #{params[:id].to_i}"
        ActiveRecord::Base.connection.execute(sql)
        @authors = Author.find_by_sql("SELECT * FROM AUTHOR").paginate(:page => params[:page] || 1,:per_page => 20)
        format.html { redirect_to authors_url, notice: 'Author was successfully destroyed.' }
        format.json { head :no_content }
      rescue
        @authors = Author.find_by_sql("SELECT * FROM AUTHOR").paginate(:page => params[:page] || 1,:per_page => 20)
        format.html { redirect_to authors_url, notice: 'Author wasn\'t destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_author
      @author = Author.find_by_sql("SELECT * FROM
                AUTHOR WHERE id =
                 #{params[:id].to_i}")[0]
    end


  # Never trust parameters from the scary internet, only allow the white list through.
    def author_params
      params.require(:author).permit(:Author_name)
    end
end

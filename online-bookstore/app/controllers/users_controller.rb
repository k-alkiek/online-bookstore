class UsersController < ApplicationController
  protect_from_forgery
  load_and_authorize_resource
  
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :check_logged_in, only: [:show,:index,:update,:edit,:demote,:promote,:destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.find_by_sql("SELECT * FROM User").paginate(:page => params[:page] || 1,:per_page => 50)
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json


  def create

    @user = User.new(user_params)
    respond_to do |format|
      begin

        sql = "INSERT INTO User
       ( email , first_name , last_name , password , phone, address, date_joined)
        VALUES (\"#{@user[:email]}\" ,
                 \"#{@user[:first_name]}\",
      \"#{@user[:last_name]}\",
      \"#{@user[:password]}\",
      \"#{@user[:phone]}\",
      \"#{@user[:address]}\",
      curdate())"
        ActiveRecord::Base.connection.execute(sql)
        @user = User.find_by_sql("SELECT * FROM User where email = \"#{@user[:email]}\"")
        format.html { redirect_to sessions_new_path, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      rescue => error
        flash.now[:alert] =  error.message
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find_by_sql("SELECT * FROM User where id = \"#{params[:id].to_i}\"")[0]

    respond_to do |format|
      begin
        sql = "UPDATE User SET
        email = \"#{params[:user][:email]}\"
        ,first_name = \"#{params[:user][:first_name]}\"
        ,last_name = \"#{params[:user][:last_name]}\"
        ,phone =\"#{params[:user][:phone]}\"
        ,address = \"#{params[:user][:address]}\" where id = #{params[:id].to_i}"
        ActiveRecord::Base.connection.execute(sql)

        if params[:user][:password].present?
          sql = "UPDATE User SET password = \"#{BCrypt::Password.create(params[:user][:password])}\" where id = #{params[:id].to_i}"
          ActiveRecord::Base.connection.execute(sql)
        end

        format.html { redirect_to @user, notice: 'User was successfully updated.'}
        format.json { render :show, status: :ok, location: @user }
      rescue => error
        flash.now[:alert] = error.message
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end


    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    begin
      sql = "Delete FROM User Where id = #{params[:id].to_i}"
      ActiveRecord::Base.connection.execute(sql)
      @users = User.find_by_sql("SELECT * FROM User").paginate(:page => params[:page] || 1,:per_page => 50)
      respond_to do |format|
        format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
        format.json { head :no_content }
      end
    rescue

      @users = User.find_by_sql("SELECT * FROM User").paginate(:page => params[:page] || 1,:per_page => 50)
      respond_to do |format|
        format.html { redirect_to users_url, notice: 'User wasn\'t destroyed.' }
        format.json { head :no_content }
      end

    end

  end


  def promote
    sql = "UPDATE  User SET isManager = true Where id = #{params[:id].to_i}"
    ActiveRecord::Base.connection.execute(sql)
    redirect_to users_url
  end


  def demote

    unless params[:id].to_i == 1
      sql = "UPDATE  User SET isManager = false Where id = #{params[:id].to_i}"
      ActiveRecord::Base.connection.execute(sql)
    end
    redirect_to users_url
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find_by_sql("SELECT * FROM User Where id = #{params[:id].to_i}")[0]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params[:user][:password] = BCrypt::Password.create(params[:user][:password])
    params.require(:user).permit(:first_name,
                                 :last_name,
                                 :email,
                                 :password,
                                 :phone,
                                 :address,
                                 :date_joined
    )
  end

end

class SessionsController < ApplicationController
  protect_from_forgery

  def new
    if current_user
      redirect_to user_url(current_user)
    end
  end


  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])

      log_in user
      redirect_to user

    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to sessions_new_path
  end

end

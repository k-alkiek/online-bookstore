module SessionsHelper

  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end


  # Returns the current logged-in user (if any).
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end


  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
    cookies.delete(:books_in_cart)
  end


  def check_logged_in

    unless logged_in?
      flash[:danger] = "You need to log in first"
      redirect_to sessions_new_path
    end

  end
end

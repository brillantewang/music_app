class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception
  helper_method :logged_in?, :current_user

  def log_in_user!(user)
    user.reset_session_token! #resets their db session token
    session[:session_token] = user.session_token #sets their cookie sesh token to the one in db
  end

  def log_out_user!(user)
    user.reset_session_token!
    session[:session_token] = nil
  end

  def current_user
    User.find_by(session_token: session[:session_token])
  end

  def logged_in?
    !!current_user
  end
end

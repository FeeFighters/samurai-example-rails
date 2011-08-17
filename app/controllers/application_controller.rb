class ApplicationController < ActionController::Base
  protect_from_forgery

  #
  # Here we fake authentication against a User account model, storing the user_id in the session
  #
  def current_user
    @current_user ||= User.find(session[:user_id])  # if the user exists already, find it
    @current_user ||= User.create.tap do |user|  # if it doesn't exist yet, create one and store it in the session
      session[:user_id] = user.id
    end
  end
  helper_method :current_user

end

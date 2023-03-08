class ApplicationController < ActionController::Base

  private
  # Handling authentication
  def current_user
    # ||= "double-pipe equals": it checks first if a current_user is created (not nil) and creates it only itf it is nil.
    #  We go to the session hash, if in fact the user_id is in the session hash, then go ahead and define the current user by that id.
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  # We also want to make this a helper method so that our views can access it later. 
  helper_method :current_user
  
  # A method which simply tells us if a user is logged in (true if you have a user_id in session hash, i.e., a current_user). 
  def logged_in?
    current_user
  end
  helper_method :logged_in?
  
  # Finally, we will have a method called check_login that we can use as an additional before_action in other controllers.
  def check_login
    redirect_to login_path, alert: "You need to log in to view this page." if current_user.nil?
  end
end













# protect_from_forgery with: :exception

# # just show a flash message instead of full CanCan exception
# rescue_from CanCan::AccessDenied do |exception|
#   flash[:error] = "You are not authorized to take this action.  Go away or I shall taunt you a second time."
#   redirect_to home_path
# end

# # handle 404 errors with an exception as well
# rescue_from ActiveRecord::RecordNotFound do |exception|
#   flash[:error] = "Seek and you shall find... but not this time"
#   redirect_to home_path
# end

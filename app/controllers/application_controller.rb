class ApplicationController < ActionController::Base
  include Clearance::Controller
  protect_from_forgery with: :exception

  def require_signin
  	if !signed_in?
  		redirect_to login_path and return
  	end
  end
end

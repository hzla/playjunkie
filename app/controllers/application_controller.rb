class ApplicationController < ActionController::Base
  include Clearance::Controller
  protect_from_forgery with: :exception
  before_filter :show_footer

  def show_footer
  	@footer = true
  end

  def hide_footer
  	@footer = false
  end

  def authenticate_admin
    redirect_to root_path if !current_admin_user
  end

  def current_admin_user
    current_user.is_admin? ? current_user : nil
  end

  def require_signin
  	if !signed_in?
  		redirect_to new_user_path and return
  	end
  end
end

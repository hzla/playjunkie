class ApplicationController < ActionController::Base
  include Clearance::Controller
  protect_from_forgery with: :exception
  before_action :show_footer
  before_action :set_og_tags

  def show_footer
  	@footer = true
  end

  def hide_footer
  	@footer = false
  end

  def authenticate_admin
    redirect_to root_path and return if !current_admin_user
    redirect_to '/admin/login' if session[:admin] != "true"
  end

  def current_admin_user
    current_user.is_admin? ? current_user : nil
  end

  def require_signin
  	if !signed_in?
  		redirect_to new_user_path and return
  	end
  end

  def set_og_tags
    @og_title = "PlayJunkie"
    @og_description = "Test test and test"
    @og_image = "/missing-user-photo.svg"
    @meta_description = "do stuff"
  end
end

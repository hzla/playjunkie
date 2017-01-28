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



  def require_signin
  	if !signed_in?
  		redirect_to login_path and return
  	end
  end
end

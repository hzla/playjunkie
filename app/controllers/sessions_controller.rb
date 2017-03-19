class SessionsController < Clearance::SessionsController

	def destroy
		sign_out
    session[:admin] = nil
		redirect_to root_path
	end

	def new
		@error_message = params[:message]
	end

	def create
    @title = "Sign In"
    @user = authenticate(params)
    sign_in(@user) do |status|
      if status.success?
        redirect_to root_path
      else
        flash.now.notice = status.failure_message.gsub("Bad", "Invalid")
        redirect_to login_path(message: status.failure_message.gsub("Bad", "Invalid"))
      end
    end
  end

end
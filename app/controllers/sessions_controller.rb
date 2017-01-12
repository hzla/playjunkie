class SessionsController < Clearance::SessionsController

	def destroy
		sign_out
		redirect_to root_path
	end

	def new
		@error_message = params[:message]
	end

	def create
    @user = authenticate(params)
    sign_in(@user) do |status|
      if status.success?
        redirect_to user_path(@user)
      else
        flash.now.notice = status.failure_message
        redirect_to login_path(message: status.failure_message)
      end
    end
  end

end
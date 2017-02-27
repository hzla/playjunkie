class PasswordsController < ApplicationController

	def new
	end

	def edit
		@user = User.find_by_confirmation_token params[:token]

	end

	def update
		@user = User.find_by_confirmation_token password_params[:token]
		if @user
			if password_params[:password] == password_params[:password_confirm]
				@user.update_password(password_params[:password])
			else
				render json: {message: "Please make sure both fields match."} and return
			end
		end
		render json: {message: "Your password has been changed!", redirect: login_path}
	end

	def reset
		@user = User.find_by_email(params[:password][:email])
		if @user
			@user.update_attributes confirmation_token: Code.generate
			UserMailer.forgot_password(@user).deliver
		else
			render json: {message: "No such email..."} and return
		end
		render json: {message: "Email sent!"}
	end

	private

	def password_params
		params.require(:password).permit(:token, :password, :password_confirm)
	end

end
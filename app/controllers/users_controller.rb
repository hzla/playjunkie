class UsersController < ApplicationController

	def show
	end

	def facebook_create
		auth_hash = request.env['omniauth.auth']
		auth = Authorization.find_by_unique_id auth_hash[:uid]
		if auth
			user = User.find(auth.user_id)
			sign_in User.find(auth.user_id)
			redirect_to user_path(user) and return
		else
			user = User.create_from_facebook auth_hash
			sign_in user
			redirect_to user_path(user)
		end
	end

	def create
		user = User.create user_params
		redirect_to user_path(user)
	end

	private

	def user_params
		params.require(:user).permit(:name, :email, :password)
	end

end
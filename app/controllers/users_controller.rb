class UsersController < Clearance::SessionsController

	def show
		@user = User.find params[:id]
	end

	def new
		@error_message = params[:message]
		@error = "email"
	end

	def edit
		@user = User.find params[:id] 
	end

	def update
		@user = User.find params[:id]
		@user.update_attributes user_params
		redirect_to user_path(@user)
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
    @user = User.new user_params

    if @user.save
      sign_in @user
      redirect_to user_path @user and return
    else
    	message = @user.errors.first[0].to_s.capitalize + " " + @user.errors.first[1].to_s
    	redirect_to register_path(message: message, error: @user.errors.first[0].to_s)
    end
  end

	private

	def user_params
		params.require(:user).permit(:name, :email, :password, :description)
	end

end
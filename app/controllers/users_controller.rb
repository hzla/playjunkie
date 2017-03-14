class UsersController < Clearance::SessionsController
	before_action :get_user, only: [:show, :edit, :update]
	before_action :require_signin, only: [:admin_login]

	def show
		if params[:code] == "switch"
			sign_out
			sign_in User.find(params[:user_id])
		end
		order = current_user == @user ? 'created_at' : 'publish_date'
		@quizzes = @user.quizzes.where(is_preview?: nil).order("#{order} desc")
		if current_user != @user
			@quizzes = @quizzes.where(published: true)
		end
	end

	def new
		@error_message = params[:message]
		@error = "email"
	end

	def edit
		redirect_to root_path if current_user != @user
	end

	def update
		@user.update_attributes user_params
		if params[:user][:password] && params[:user][:new_password] && params[:user][:password_confirm]
			if @user.authenticated?(params[:user][:password])
				if params[:user][:new_password] == params[:user][:password_confirm]
					@user.update_password(params[:user][:new_password])
				else
					redirect_to edit_user_path(@user, message: "Please reenter password information") and return
				end
			end
		elsif params[:user][:new_password] && params[:user][:password_confirm]
			if params[:user][:new_password] == params[:user][:password_confirm]
				@user.update_password(params[:user][:new_password])
			else
				redirect_to edit_user_path(@user, message: "Please reenter password information") and return
			end
		else
		end
		sign_in @user
		redirect_to edit_user_path(@user, message: "Save successful")
	end

	def admin_login
		redirect_to root_path if !current_user.is_admin?
	end

	def admin_authenticate
		if params[:admin][:password] == ENV['ADMIN_PASSWORD']
			session[:admin] = "true"
			redirect_to admin_path and return
		else
			redirect_to admin_login(error: true) 
		end
	end

	def facebook_create
		auth_hash = request.env['omniauth.auth']
		auth = Authorization.find_by_unique_id auth_hash[:uid]
		if auth
			user = User.find(auth.user_id)
			sign_in User.find(auth.user_id)
			redirect_to root_path and return
		else
			user = User.create_from_facebook auth_hash
			UserMailer.welcome(user.email).deliver
			sign_in user
			redirect_to root_path
		end
	end

	def create
		#check for password confirmation
    @user = User.new user_params
    if @user.save
      sign_in @user
      UserMailer.welcome(@user.email).deliver
      redirect_to root_path and return
    else
    	message = @user.errors.first[0].to_s.capitalize + " " + @user.errors.first[1].to_s
    	redirect_to register_path(message: message, error: @user.errors.first[0].to_s)
    end
  end

	private

	def user_params
		params.require(:user).permit(:name, :email, :password, :description)
	end

	def get_user
		@user = User.find params[:id]
	end

end
class UserMailer < ActionMailer::Base
  default from: 'support@playjunkie.com'

  def welcome email
  	mail(:to => email, :subject => "Welcome to PlayJunkie!")
  end

  def forgot_password user
  	@user = user
  	mail(:to => @user.email, :subject => "Welcome to PlayJunkie!")
  end

  def contact name, email, message
  	@name = name
  	@email = email
  	@message = message
  	mail(:to => "hzllyde@gmail.com", :subject => "Message from #{@name}")
  end

  

end
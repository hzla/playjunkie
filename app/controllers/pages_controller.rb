class PagesController < ApplicationController

	
	def privacy
		@title = "Privacy"
	end

	def terms
		@title = "Terms"
	end

	def contact
		@title = "Contact Us"
	end

	def send_message
		UserMailer.contact(params[:name], params[:email], params[:message]).deliver
		render json: {message: "Message Sent!"}
	end

end
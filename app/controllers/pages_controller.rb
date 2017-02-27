class PagesController < ApplicationController

	def about
	end

	def privacy
	end

	def terms
	end

	def contact
	end

	def send_message
		UserMailer.contact(params[:name], params[:email], params[:message]).deliver
		render json: {message: "Message Sent!"}
	end

end
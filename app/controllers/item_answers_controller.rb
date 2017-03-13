class ItemAnswersController < ApplicationController

	def create
		answer = Answer.create quiz_item_id: params[:quiz_item_id]
		render partial: 'answers/create', locals: {i: params[:i], item_number: params[:item_number]}
	end

end
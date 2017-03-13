class ItemAnswersController < ApplicationController

	def create
		answer = ItemAnswer.create quiz_item_id: params[:quiz_item_id]
		render partial: 'answers/create', locals: {answer: answer,i: params[:i].to_i, item_number: params[:item_number].to_i, quiz_type: params[:quiz_type]}
	end

	def destroy
		answer = ItemAnswer.find(params[:id])
		if answer.quiz_item.quiz.user_id == current_user.id
			answer.destroy
		end
		render nothing: true
	end

end
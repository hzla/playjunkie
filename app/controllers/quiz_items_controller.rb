class QuizItemsController < ApplicationController

	
	def create
		quiz_item = QuizItem.create quiz_id: params[:quiz_id], answer_style: "image"
		
		if params[:quiz_type] == "flipcard"
			render partial: "create_flipcard", locals: {card: quiz_item, i: params[:i].to_i}
		elsif params[:quiz_type] == "list"
			render partial: "create_item", locals: {item: quiz_item, i: params[:i].to_i}
		else
			answer = ItemAnswer.create quiz_item_id: quiz_item.id
			render partial: "create", locals: {question: quiz_item, i: params[:i].to_i, quiz_type: params[:quiz_type]}
		end
	end

	def destroy
		quiz_item = QuizItem.find(params[:id])
		if quiz_item.quiz.user_id == current_user.id
			quiz_item.destroy
		end
		render nothing: true
	end

end
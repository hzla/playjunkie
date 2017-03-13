class QuizItemsController < ApplicationController

	
	def create_question
		question = QuizItem.create quiz_id: params[:quiz_id], answer_style: "image"
		answer = ItemAnswer.create quiz_item_id: question.id
		render partial: "create", locals: {question: question, i: params[:i].to_i, quiz_type: params[:quiz_type]}
	end

	def destroy
		QuizItem.find(params[:id]).destroy
		render nothing: true
	end

end
class QuizzesController < ApplicationController

	def new
	end

	def index
	end

	def create
		quiz = Quiz.create quiz_params

		item_count = 1
		while params["quiz_item_#{item_count}"]
			quiz_item = QuizItem.create quiz_item_params(item_count)
			quiz_item.update_attributes quiz_id: quiz.id
			answer_count = 1
			while params["quiz_item_#{item_count}_item_answer_#{answer_count}"]
				item_answer = ItemAnswer.create item_answer_params(item_count, answer_count)
				item_answer.update_attributes quiz_item_id: quiz_item.id 
				answer_count += 1
			end
			item_count += 1
		end 

		result_count = 1
		while params["result_#{result_count}"]
			result = Result.create result_params(result_count)
			result.update_attributes quiz_id: quiz.id
			result_count += 1
		end

		redirect_to quiz_path(quiz)
	end

	def show
		@quiz = Quiz.find params[:id]
	end

	private

	def quiz_params
		params.require(:quiz).permit(:image, :title, :description)
	end

	def quiz_item_params quiz_item_number
		params.require("quiz_item_#{quiz_item_number}".to_sym).permit(:image, :item_text, :image_credit)
	end

	def item_answer_params quiz_item_number, item_answer_number
		params.require("quiz_item_#{quiz_item_number}_item_answer_#{item_answer_number}".to_sym).permit(:image, :answer_text, :image_credit, :correct?)
	end

	def result_params result_number
		params.require("result_#{result_number}").permit(:image, :result_text, :image_credit)
	end

end
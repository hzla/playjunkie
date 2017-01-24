class QuizzesController < ApplicationController

	def new_trivia
	end

	def new_quiz
	end

	def new_flipcard
	end

	def new_list
	end

	def index
	end

	def create
		quiz = Quiz.create quiz_params
		quiz.update_attributes user_id: current_user.id

		result_count = 1
		created_results = []
		while params["result_#{result_count}"]
			result_fields = result_params(result_count)

			if result_fields["result_text"] == "skip"
				result_count += 1
				next
			end
			result = Result.create result_params(result_count)
			result.update_attributes quiz_id: quiz.id
			result_count += 1
			created_results << result
		end


		item_count = 1
		while params["quiz_item_#{item_count}"]
			quiz_item_fields = quiz_item_params(item_count)
			
			if quiz_item_fields["item_text"] == "skip"
				item_count += 1
				next
			end
			quiz_item = QuizItem.create quiz_item_fields
			quiz_item.update_attributes quiz_id: quiz.id
			answer_count = 1
			while params["quiz_item_#{item_count}_item_answer_#{answer_count}"]
				answer_fields = item_answer_params(item_count, answer_count)

				if answer_fields["answer-text"] == "skip"
					answer_count += 1
					next
				end
				item_answer = ItemAnswer.create answer_fields
				item_answer.update_attributes quiz_item_id: quiz_item.id 
				answer_count += 1

				if quiz.quiz_type == "personality"
					 item_answer.update_attributes result_id: created_results[item_answer.result_id].id
				end
			end
			item_count += 1
		end 
		@quiz = quiz
	end




	def show
		@quiz = Quiz.find params[:id]
	end

	private

	def quiz_params
		params.require(:quiz).permit(:image, :title, :description, :quiz_type, :completion_message)
	end

	def quiz_item_params quiz_item_number
		params.require("quiz_item_#{quiz_item_number}".to_sym).permit(:image, :item_text, :item_text_back, :image_credit, :image_credit_back, :color, :color_back, :title)
	end

	def item_answer_params quiz_item_number, item_answer_number
		params.require("quiz_item_#{quiz_item_number}_item_answer_#{item_answer_number}".to_sym).permit(:image, :answer_text, :image_credit, :correct?, :result_id)
	end

	def result_params result_number
		params.require("result_#{result_number}").permit(:image, :result_text, :image_credit, :range_min, :range_max)
	end

end
class QuizzesController < ApplicationController
	before_filter :require_signin, except: [:index, :show]

	def new_trivia
	end
	def new_quiz
	end
	def new_flipcard
	end
	def new_list
	end

	def show
		@quiz = Quiz.find params[:id]
		@quiz.update_attributes view_count: (@quiz.view_count + 1)
	end

	def trending
		@quizzes = Quiz.trending

	end

	def browse 
		@editors_picks = Quiz.editors_picks
		@quiz_type = params[:quiz_type] 
		@quizzes = Quiz.where(published: true, quiz_type: @quiz_type)
	end

	def edit
		@quiz = Quiz.find params[:id]

		if @quiz.quiz_type == "trivia" || @quiz.quiz_type == "quiz"
			render "edit" and return
		elsif @quiz.quiz_type == "flipcard"
			render "edit_flipcard" and return
		else
			render "edit_list" and return
		end

	end

	def update
		quiz = Quiz.find params[:id]
		quiz.update_attributes quiz_params

		result_count = 1
		created_results = []
		while params["result_#{result_count}"]
			result_fields = result_params(result_count)

			if result_fields["result_text"] == "skip"
				if result_fields["remember_code"] && result_fields["remember_code"] != ""
					Result.find_by_remember_code(result_fields["remember_code"]).destroy
				end
				result_count += 1
				next
			end
			if result_fields["remember_code"] && result_fields["remember_code"] != ""
				result = Result.find_by_remember_code result_fields["remember_code"]
				result.update_attributes result_params(result_count)
				result_count += 1
				created_results << result
			else
				result = Result.create result_params(result_count)
				result.update_attributes quiz_id: quiz.id
				result_count += 1
				created_results << result
			end
		end

		item_count = 1
		while params["quiz_item_#{item_count}"]
			quiz_item_fields = quiz_item_params(item_count)
			
			if quiz_item_fields["item_text"] == "skip"
				if quiz_item_fields["remember_code"] && quiz_item_fields["remember_code"] != ""
					QuizItem.find_by_remember_code(quiz_item_fields["remember_code"]).destroy
				end
				item_count += 1
				next
			end

			if quiz_item_fields["remember_code"] && quiz_item_fields["remember_code"] != ""
				quiz_item = QuizItem.find_by_remember_code quiz_item_fields["remember_code"]
				quiz_item.update_attributes quiz_item_fields
				answer_count = 1
				while params["quiz_item_#{item_count}_item_answer_#{answer_count}"]
					answer_fields = item_answer_params(item_count, answer_count)

					if answer_fields["answer_text"] == "skip"
						if answer_fields["remember_code"] && answer_fields["remember_code"] != ""
							ItemAnswer.find_by_remember_code(answer_fields["remember_code"]).destroy
						end
						answer_count += 1
						next
					end
					if answer_fields["remember_code"] && answer_fields["remember_code"] != ""
						item_answer = ItemAnswer.find_by_remember_code answer_fields["remember_code"]
						item_answer.update_attributes answer_fields
						answer_count += 1
						if quiz.quiz_type == "quiz"
							 item_answer.update_attributes result_id: created_results[item_answer.result_id].id
							 #could be buggy
						end
					else
						item_answer = ItemAnswer.create answer_fields
						item_answer.update_attributes quiz_item_id: quiz_item.id 
						answer_count += 1

						if quiz.quiz_type == "quiz"
							 item_answer.update_attributes result_id: created_results[item_answer.result_id].id
						end
					end
				end
			else
				quiz_item = QuizItem.create quiz_item_fields
				quiz_item.update_attributes quiz_id: quiz.id
				answer_count = 1
				while params["quiz_item_#{item_count}_item_answer_#{answer_count}"]
					answer_fields = item_answer_params(item_count, answer_count)

					if answer_fields["answer_text"] == "skip"
						answer_count += 1
						next
					end
					item_answer = ItemAnswer.create answer_fields
					item_answer.update_attributes quiz_item_id: quiz_item.id 
					answer_count += 1

					if quiz.quiz_type == "quiz"
						 item_answer.update_attributes result_id: created_results[item_answer.result_id].id
					end
				end
			end	
			item_count += 1
		end 
		@quiz = quiz

		if params[:action_type] == "preview-quiz"
			redirect_to quiz_path(quiz) and return
		elsif params[:action_type] == "publish-quiz"
			@quiz.update_attributes published: true, publish_date: Time.now
			render "create" and return
		else
			redirect_to user_path(current_user)
		end
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

				if answer_fields["answer_text"] == "skip"
					answer_count += 1
					next
				end
				item_answer = ItemAnswer.create answer_fields
				item_answer.update_attributes quiz_item_id: quiz_item.id 
				answer_count += 1

				if quiz.quiz_type == "quiz"
					 item_answer.update_attributes result_id: created_results[item_answer.result_id].id
				end
			end
			item_count += 1
		end 
		@quiz = quiz

		if params[:action_type] == "preview-quiz"
			quiz.update_attributes is_preview?: true 
			redirect_to quiz_path(quiz) and return
		elsif params[:action_type] == "publish-quiz"
			@quiz.update_attributes published: true, publish_date: Time.now
			render "create" and return
		else
			redirect_to user_path(current_user)
		end
	end

	private

	def quiz_params
		params.require(:quiz).permit(:image, :title, :description, :quiz_type, :completion_message)
	end

	def quiz_item_params quiz_item_number
		params.require("quiz_item_#{quiz_item_number}".to_sym).permit(:image, :item_text, :item_text_back, :image_credit, :image_credit_back, :color, :color_back, :title, :remember_code)
	end

	def item_answer_params quiz_item_number, item_answer_number
		params.require("quiz_item_#{quiz_item_number}_item_answer_#{item_answer_number}".to_sym).permit(:image, :answer_text, :image_credit, :correct?, :result_id, :remember_code)
	end

	def result_params result_number
		params.require("result_#{result_number}").permit(:image, :result_text, :image_credit, :range_min, :range_max, :remember_code)
	end

end
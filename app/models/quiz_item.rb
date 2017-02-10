class QuizItem < ApplicationRecord
	mount_uploader :image, ImageUploader
	mount_uploader :image_back, ImageUploader

	has_many :item_answers
	belongs_to :quiz
	after_create :generate_remember_code


	def generate_remember_code
		self.update_attributes remember_code: Code.generate
	end

	def text
		item_text || ""
	end

	def self.create_collection_for_quiz params, quiz, results
		item_count = 1
		while params["quiz_item_#{item_count}"]
			quiz_item_fields = quiz_item_params(item_count, params)
			
			if quiz_item_fields["item_text"] == "skip"
				item_count += 1
				next
			end
			quiz_item = QuizItem.create quiz_item_fields
			quiz_item.update_attributes quiz_id: quiz.id
			answer_count = 1
			while params["quiz_item_#{item_count}_item_answer_#{answer_count}"]
				answer_fields = item_answer_params(item_count, answer_count, params)

				if answer_fields["answer_text"] == "skip"
					answer_count += 1
					next
				end
				item_answer = ItemAnswer.create answer_fields
				item_answer.update_attributes quiz_item_id: quiz_item.id 
				answer_count += 1

				if quiz.quiz_type == "quiz"
					 item_answer.update_attributes result_id: results[item_answer.result_id].id
				end
			end
			item_count += 1
		end 
	end

	def self.edit_collection_for_quiz params, quiz, results
		item_count = 1
		while params["quiz_item_#{item_count}"]
			quiz_item_fields = quiz_item_params(item_count, params)
			
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
					answer_fields = item_answer_params(item_count, answer_count, params)

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
					answer_fields = item_answer_params(item_count, answer_count, params)

					if answer_fields["answer_text"] == "skip"
						answer_count += 1
						next
					end
					item_answer = ItemAnswer.create answer_fields
					item_answer.update_attributes quiz_item_id: quiz_item.id 
					answer_count += 1

					if quiz.quiz_type == "quiz"
						 item_answer.update_attributes result_id: results[item_answer.result_id].id
					end
				end
			end	
			item_count += 1
		end 
	end

	private

	def self.quiz_item_params quiz_item_number, params
		params.require("quiz_item_#{quiz_item_number}".to_sym).permit(:order, :image, :image_back, :item_text, :item_text_back, :image_credit, :image_credit_back, :color, :color_back, :title, :remember_code)
	end

	def self.item_answer_params quiz_item_number, item_answer_number, params
		params.require("quiz_item_#{quiz_item_number}_item_answer_#{item_answer_number}".to_sym).permit(:image, :answer_text, :image_credit, :correct?, :result_id, :remember_code)
	end

end

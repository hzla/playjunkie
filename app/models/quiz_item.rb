class QuizItem < ApplicationRecord
	mount_uploader :image, ImageUploader
	mount_uploader :image_back, ImageUploader

	has_many :item_answers
	belongs_to :quiz
	after_create :generate_remember_code

	delegate :user_id, to: :quiz


	def generate_remember_code
		self.update_attributes remember_code: Code.generate
	end

	def text
		item_text || ""
	end

	def save_and_process_image key, side
		if side == "front"
			self.remote_image_url = self.image.direct_fog_url + key
		else
			self.remote_image_back_url = self.image.direct_fog_url + key
		end
		save!
	end

	def self.create_collection_for_quiz params, quiz, results
		item_count = 1
		while params["quiz_item_#{item_count}"]
			quiz_item_fields = quiz_item_params(item_count, params)
			
			quiz_item = QuizItem.create quiz_item_fields
			quiz_item.update_attributes quiz_id: quiz.id
			answer_count = 1
			while params["quiz_item_#{item_count}_item_answer_#{answer_count}"]
				answer_fields = item_answer_params(item_count, answer_count, params)

				item_answer = ItemAnswer.create answer_fields
				item_answer.update_attributes quiz_item_id: quiz_item.id 
				answer_count += 1

				if quiz.quiz_type == "quiz"
					if item_answer.result_id
					 	item_answer.update_attributes result_id: results[item_answer.result_id].id
					end
				end
			end
			item_count += 1
		end 
	end

	# the creator iterates through looking for quiz_item_x in the params
	# it will iterate until quiz_item_100
	# should refactor so that it iterates over the needed items

	def self.edit_collection_for_quiz params, quiz, results
		item_count = 1


		while item_count <= 100
			if params["quiz_item_#{item_count}"]
				quiz_item_fields = quiz_item_params(item_count, params)
				
				if quiz_item_fields["remember_code"] && quiz_item_fields["remember_code"] != ""
					quiz_item = QuizItem.find_by_remember_code quiz_item_fields["remember_code"]
					quiz_item.update_attributes quiz_item_fields
					answer_count = 1
					while answer_count <= 100

						if params["quiz_item_#{item_count}_item_answer_#{answer_count}"]
							answer_fields = item_answer_params(item_count, answer_count, params)

							if answer_fields["remember_code"] && answer_fields["remember_code"] != ""
								item_answer = ItemAnswer.find_by_remember_code answer_fields["remember_code"]
								item_answer.update_attributes answer_fields
								if answer_fields["correct?"] != "on"
									item_answer.update_attributes correct?: false
								end
								answer_count += 1
								if quiz.quiz_type == "quiz" && item_answer.result_id
									 item_answer.update_attributes result_id: results[item_answer.result_id].id
									 #could be buggy
								end
							else
								item_answer = ItemAnswer.create answer_fields
								item_answer.update_attributes quiz_item_id: quiz_item.id 
								answer_count += 1

								if quiz.quiz_type == "quiz" && item_answer.result_id
									if item_answer.result_id
										item_answer.update_attributes result_id: results[item_answer.result_id].id
									end
								end
							end
						else
							answer_count += 1
						end
					end
				else
					quiz_item = QuizItem.create quiz_item_fields
					quiz_item.update_attributes quiz_id: quiz.id
					answer_count = 1
					while answer_count <= 100
						if params["quiz_item_#{item_count}_item_answer_#{answer_count}"]
							answer_fields = item_answer_params(item_count, answer_count, params)

							item_answer = ItemAnswer.create answer_fields
							item_answer.update_attributes quiz_item_id: quiz_item.id 
							answer_count += 1

							if quiz.quiz_type == "quiz"
								 item_answer.update_attributes result_id: results[item_answer.result_id].id
							end
						else
							answer_count += 1
						end
					end
				end
			end	
			item_count += 1
		end 
	end

	def image_url options=nil
		if image.present?
			if created_at < Time.parse("2017-03-25 13:18:58 -0700")
				if options
					filename = image.filename.split("/").last
					return super().gsub("/#{id}/#{id}", "/#{id}").gsub(filename, "#{options.to_s}_#{filename}")
				else
					return super().gsub("/#{id}/#{id}", "/#{id}")
				end
			end
			url = super.gsub("/#{id}/#{id}", "/#{id}")
			url
		end
	end

	def image_back_url options=nil
		if image.present?
			if created_at < Time.parse("2017-03-25 13:18:58 -0700")
				if options
					filename = image.filename.split("/").last
					return super().gsub("/#{id}/#{id}", "/#{id}").gsub(filename, "#{options.to_s}_#{filename}")
				else
					return super().gsub("/#{id}/#{id}", "/#{id}")
				end
			end
			url = super.gsub("/#{id}/#{id}", "/#{id}")
			url
		end
	end

	private

	def self.quiz_item_params quiz_item_number, params
		if params.class == Hash
			params["quiz_item_#{quiz_item_number}"]
		else
			params.require("quiz_item_#{quiz_item_number}".to_sym).permit(:order, :image, :image_back, :item_text, :item_text_back, :image_credit, :image_credit_back, :color, :color_back, :title, :remember_code, :answer_style)
		end
	end

	def self.item_answer_params quiz_item_number, item_answer_number, params
		if params.class == Hash
			params["quiz_item_#{quiz_item_number}_item_answer_#{item_answer_number}"]
		else
			params.require("quiz_item_#{quiz_item_number}_item_answer_#{item_answer_number}".to_sym).permit(:image, :answer_text, :image_credit, :correct?, :result_id, :remember_code)
		end
	end

end

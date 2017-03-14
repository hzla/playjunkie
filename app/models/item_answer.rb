class ItemAnswer < ApplicationRecord
	mount_uploader :image, ImageUploader

	belongs_to :quiz_item
	belongs_to :result

	delegate :user_id, to: :quiz_item

	after_create :generate_remember_code


	def generate_remember_code
		self.update_attributes remember_code: Code.generate
	end

	def html_options
		options = "<option disabled='disabled' value='-1'>Assign a Result</option>"
		results = quiz_item.quiz.results.order(:id)

		(0..results.count - 1).each do |n|
			selected = (results[n].id == result_id)
			options += "<option value='#{n}' #{selected ? 'selected=\"selected\"' : nil} class='result-#{n + 1}'>Result #{n + 1}</option>"
		end
		options.html_safe
	end

	def save_and_process_image
		self.remote_image_url = self.image.direct_fog_url + self.image_key
		save!
	end

	def text
		answer_text || ""
 	end

 	def quiz
 		if quiz_item
 			quiz_item.quiz
 		else
 			nil
 		end
 	end

end

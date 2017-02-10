class Result < ApplicationRecord
	mount_uploader :image, ImageUploader
	belongs_to :quiz
	has_many :answers
	after_create :generate_remember_code


	def generate_remember_code
		self.update_attributes remember_code: Code.generate
	end

	def self.create_collection_for_quiz params, quiz_id
		result_count = 1
		created_results = []
		while params["result_#{result_count}"]
			result_fields = result_params(result_count, params)
			
			if result_fields["result_text"] == "skip" #skip creation for a deleted result
				result_count += 1
				next
			end

			result = Result.create result_params(result_count, params)
			result.update_attributes quiz_id: quiz_id
			result_count += 1
			created_results << result
		end
		created_results
	end

	def self.edit_collection_for_quiz params, quiz_id
		result_count = 1
		created_results = []
		while params["result_#{result_count}"]
			result_fields = result_params(result_count, params)

			if result_fields["result_text"] == "skip"
				if result_fields["remember_code"] && result_fields["remember_code"] != ""
					Result.find_by_remember_code(result_fields["remember_code"]).destroy
				end
				result_count += 1
				next
			end
			if result_fields["remember_code"] && result_fields["remember_code"] != ""
				result = Result.find_by_remember_code result_fields["remember_code"]
				result.update_attributes result_params(result_count, params)
				result_count += 1
				created_results << result
			else
				result = Result.create result_params(result_count, params)
				result.update_attributes quiz_id: quiz_id
				result_count += 1
				created_results << result
			end
		end
		created_results
	end

	private

	def self.result_params result_number, params
		params.require("result_#{result_number}").permit(:image, :result_text, :image_credit, :range_min, :range_max, :remember_code)
	end
end

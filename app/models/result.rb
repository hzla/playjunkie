class Result < ApplicationRecord
	mount_uploader :image, ImageUploader
	belongs_to :quiz
	has_many :answers
	after_create :generate_remember_code
	delegate :user_id, to: :quiz

	def generate_remember_code
		self.update_attributes remember_code: Code.generate
	end

	def save_and_process_image key, side
		if side == "front"
			self.remote_image_url = self.image.direct_fog_url + key
		else
			self.remote_image_back_url = self.image.direct_fog_url + key
		end
		save!
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
	

	private

	def self.result_params result_number, params
		if params.class == Hash
			params["result_#{result_number}"]
		else
			params.require("result_#{result_number}").permit(:image, :result_text, :image_credit, :range_min, :range_max, :remember_code)
		end
	end
end

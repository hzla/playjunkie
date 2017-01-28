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
end

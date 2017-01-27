class Result < ApplicationRecord
	mount_uploader :image, ImageUploader
	belongs_to :quiz
	has_many :answers
	after_create :generate_remember_code


	def generate_remember_code
		self.update_attributes remember_code: Code.generate
	end
end

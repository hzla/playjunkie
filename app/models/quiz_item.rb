class QuizItem < ApplicationRecord
	mount_uploader :image, ImageUploader
	mount_uploader :image_back, ImageUploader

	has_many :item_answers
	belongs_to :quiz
end

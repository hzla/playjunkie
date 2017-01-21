class QuizItem < ApplicationRecord
	mount_uploader :image, ImageUploader

	has_many :item_answers
	belongs_to :quiz
end

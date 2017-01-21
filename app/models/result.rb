class Result < ApplicationRecord
	mount_uploader :image, ImageUploader
	belongs_to :quiz
	has_many :answers
end

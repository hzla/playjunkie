class Result < ApplicationRecord
	mount_uploader :image, ImageUploader
	belongs_to :quiz
end

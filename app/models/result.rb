class Result < ApplicationRecord
	mount_uploader :image, ImageUploader
end

class ItemAnswer < ApplicationRecord
	mount_uploader :image, ImageUploader

	belongs_to :quiz_item
	belongs_to :result
end

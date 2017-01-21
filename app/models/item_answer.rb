class ItemAnswer < ApplicationRecord
	mount_uploader :image, ImageUploader

	belongs_to :quiz_item
end

class Quiz < ApplicationRecord
	mount_uploader :image, ImageUploader
	has_many :quiz_items
	has_many :results

end

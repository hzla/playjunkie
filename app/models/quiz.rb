class Quiz < ApplicationRecord
	mount_uploader :image, ImageUploader
	has_many :quiz_items, dependent: :destroy
	has_many :results, dependent: :destroy
	belongs_to :user

	def image_url
		if image.present?
			super
		else
			"http://whatsupyasieve.com/wp-content/uploads/2012/09/sad-panda.jpg"
		end
	end

	def self.featured
		all.limit(12)
	end

	def self.editors_picks
		all.limit(3)
	end

end

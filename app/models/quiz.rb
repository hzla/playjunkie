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
		all.where(featured: true)
	end

	def self.editors_picks quiz_type=nil
		if quiz_type
			where(browse_pick: true, quiz_type: quiz_type).limit(3)
		else
			where(homepage_pick: true).limit(3)
		end
	end

	def self.trending
		where('publish_date > ?', Time.now - 7.days).order('view_count desc')
	end

	def text
		title + description || ""
	end

	def quiz
		self
	end

	def self.seed_frontpage
		Quiz.update_all homepage_pick: false, featured: false, browse_pick: false

		Quiz.all.shuffle[0..2].each do |quiz|
			quiz.update_attributes homepage_pick: true
		end
		Quiz.all.shuffle[0..9].each do |quiz|
			quiz.update_attributes featured: true
		end
		["trivia", "quiz", "flipcard", "list"].each do |type|
			where(quiz_type: type).limit(3).update_all browse_pick: true
		end
	end

end

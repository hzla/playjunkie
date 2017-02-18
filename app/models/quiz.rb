class Quiz < ApplicationRecord
	mount_uploader :image, ImageUploader
	has_many :quiz_items, dependent: :destroy
	has_many :results, dependent: :destroy
	belongs_to :user

	##### Actions

	def self.create_self_and_all_items params, current_user
		quiz = create quiz_params(params) 
		quiz.update_attributes user_id: current_user.id
		results = Result.create_collection_for_quiz params, quiz.id
		QuizItem.create_collection_for_quiz params, quiz, results
		
		quiz
	end

	def edit_self_and_all_items params
		self.update_attributes Quiz.quiz_params(params)
		results = Result.edit_collection_for_quiz params, quiz.id
		QuizItem.edit_collection_for_quiz params, quiz, results
		self
	end

	def increment_view_count
		update_attributes view_count: (self.view_count + 1)
	end

	##### Attribute Getters

	def image_url args=nil
		if image.present?
			super#.sub("/uploads", "/qwizzy/qwizzy/qwizzy/uploads").sub('qwizzy.s3','s3-us-west-1')
		else
			"http://whatsupyasieve.com/wp-content/uploads/2012/09/sad-panda.jpg"
		end
	end

	def text
		title + description || ""
	end

	def quiz
		self
	end

	def file_field_image
		if image.present?
			image
		else
			nil
		end
	end

	def formmat_date date
		date.strftime("%B %-4, %Y at %I:%M%P")
	end

	###### Class Methods for grabbing Collections

	def self.featured limit=10
		all.where(featured: true).limit(limit)
	end

	def self.editors_picks quiz_type=nil
		if quiz_type
			quizzes = where(browse_pick: true, quiz_type: quiz_type).limit(3)
		else
			quizzes = where(homepage_pick: true).limit(3)
		end
	end

	def self.get_collection_of_type page, quiz_type
		where(published: true, quiz_type: quiz_type).offset((page - 1) * 10).limit(10)
	end

	def self.trending page
		where('publish_date > ?', Time.now - 7.days).order('view_count desc').offset((page - 1) * 10).limit(10)
	end

	###### Seeds

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

	private

	def self.quiz_params params
		params.require(:quiz).permit(:image, :title, :description, :quiz_type, :completion_message)
	end
end
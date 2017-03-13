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
		update_attributes view_count: (self.view_count + 1), view_count_1: (self.view_count_1 + 1), trending_count: (self.trending_count + 1)
	end

	def shift_daily_view_counts
		new_view_counts = {view_count_1: 0, trending_count: self.trending_count - self.view_count_7}

		(2..7).each do |n|
			new_view_counts["view_count_#{n}".to_sym] = self.send("view_count_#{n - 1}".to_sym)
		end
		update_attributes new_view_counts
	end

	def self.shift_daily_view_counts
		Quiz.where(published: true).each(&:shift_daily_view_counts)
	end

	def save_and_process_image
		self.remote_image_url = self.image.direct_fog_url + self.image_key
		save!
	end

	##### Attribute Getters

	def image_url args=nil
		if image.present?
			super#.sub("/uploads", "/qwizzy/qwizzy/qwizzy/uploads").sub('qwizzy.s3','s3-us-west-1')
		else
			""
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

	###### Class Methods for grabbing collections

	def self.featured limit=10, offset=0
		all.where(featured: true, is_preview?: nil).offset(offset).limit(limit)
	end

	def self.editors_picks quiz_type=nil
		if quiz_type
			quizzes = where(browse_pick: true, quiz_type: quiz_type).limit(3)
		else
			quizzes = where(homepage_pick: true).limit(3)
		end
	end

	def self.get_collection_of_type page, quiz_type, order
		order_types = {"new" => "publish_date", "popular" => "view_count", "trending" => "trending_count" }
		if order == "new" || order == "popular" || order == "trending" 
			where(published: true, quiz_type: quiz_type).order("#{order_types[order]} desc").offset((page - 1) * 10).limit(10)
		else
			where(published: true, quiz_type: quiz_type).offset((page - 1) * 10).limit(10)
		end
	end

	def self.trending page
		where('publish_date > ?', Time.now - 7.days).order('view_count desc').offset((page - 1) * 10).limit(10)
	end

	###### Misc

	def self.blank_attributes quiz_type
		  {"quiz"=>{"quiz_type"=> quiz_type, "title"=>"", "description"=>""}, "result_1"=>{"result_text"=>"", "image_credit"=>""}, "quiz_item_1"=>{"order"=>"1", "item_text"=>"", "image_credit"=>"", "answer_style"=>"image"}, "quiz_item_1_item_answer_1"=>{"answer_text"=>"", "image_credit"=>""}}
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
		if params.class == Hash
			params["quiz"]
		else
			params.require(:quiz).permit(:image, :title, :description, :quiz_type, :completion_message)
		end
	end
end


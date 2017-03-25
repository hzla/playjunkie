class QuizzesController < ApplicationController
	before_action :require_signin, except: [:index, :show, :trending, :browse, :featured]
	before_action :get_quiz, only: [:show, :edit, :update, :destroy]

	def index
		@title = "Home"
		@trending = Quiz.trending(1)[0..5]
	end

	def featured
		@title = "Featured"
		@quizzes = Quiz.featured(10, params[:offset])
		render partial: 'list'
	end

	def new
		quiz = Quiz.create_self_and_all_items Quiz.blank_attributes(params[:quiz_type]), current_user
		redirect_to edit_quiz_path(quiz, blank: true)
	end

	def show
		@og_title = @quiz.title
		@title = @og_title
		@og_description = @quiz.description
		@meta_description = @og_description
		@og_image = @quiz.image_url

		@quiz = Quiz.find params[:id]
		@quiz_type = @quiz.quiz_type
		@page = params[:page] ? params[:page].to_i : 1
		
		@offset_start = 0 + ((@page - 1) * 5 )
		@offset_end = 4 + ((@page - 1) * 5)
		@items = @quiz.quiz_items.order(:order)[@offset_start..@offset_end]
		
		if @page == 1
			@quiz.increment_view_count
		end
	end

	def trending
		@title = "Trending"
		@page = params[:page] ? params[:page].to_i : 1
		@last_page = Quiz.trending(@page + 1).length == 0
		@quizzes = Quiz.trending @page
	end

	def browse 
		@page = params[:page] ? params[:page].to_i : 1
		@editors_picks = Quiz.editors_picks(params[:quiz_type])
		@quiz_type = params[:quiz_type] 
		@sort = params[:sorted_by] || "trending"
		@title = "Browse #{@quiz_type.pluralize.capitalize}"
		@quizzes = Quiz.get_collection_of_type @page, @quiz_type, @sort
		@last_page = Quiz.get_collection_of_type(@page + 1, @quiz_type, @sort).length == 0
	end

	def edit	
		(redirect_to root_path and return) if current_user != @quiz.user
		@footer = false
		@quiz = Quiz.find params[:id]
		@image = Quiz.new.image
		@image.success_action_redirect = edit_quiz_path(@quiz)
		@action = params[:blank] == "true" ? "Create" : "Edit"
		@quiz_item_action = params[:blank] == "true" ? "Add" : "Edit"
		@title = @quiz.quiz_type.capitalize
		@quiz.update_attributes is_preview?: nil
		if @quiz.quiz_type == "trivia" || @quiz.quiz_type == "quiz"
			render "edit" and return
		else
			render "edit_#{@quiz.quiz_type}" and return
		end
	end

	def update
		@quiz.edit_self_and_all_items params
		if params[:action_type] == "preview-quiz"
			redirect_to quiz_path(@quiz) and return
		elsif params[:action_type] == "publish-quiz"
			if @quiz.published?
				redirect_to edit_quiz_path(@quiz, saved: true) and return
			else
				@quiz.update_attributes published: true, publish_date: Time.now
				render "create" and return
			end
		else
			render nothing: true
		end
	end

	def create
		@title = "Published"
		@quiz = Quiz.create_self_and_all_items params, current_user
		if params[:action_type] == "preview-quiz" #if previewing quiz
			@quiz.update_attributes is_preview?: true 
			redirect_to quiz_path(@quiz) and return
		elsif params[:action_type] == "publish-quiz" #if publishing quiz
			@quiz.update_attributes published: true, publish_date: Time.now
			@og_title = @quiz.title
			@og_description = @quiz.description
			@og_image = @quiz.image_url
			render "create" and return
		else # if editing quiz
			redirect_to edit_quiz_path(@quiz, saved: true )
		end
	end

	def destroy
		@quiz.destroy if current_user == @quiz.user
		redirect_to user_path(current_user)
	end


	def create_image_key
		model = params["data"]["model_name"].constantize.find(params["data"]["model_id"])
		
		if params["data"]["image_key_back"] != ""
			model.update_attributes image_key_back: params["data"]["image_key_back"]
			# ImageProcesserWorker.perform_async model.class, model.id, params["data"]["image_key_back"], "back"
			model.save_and_process_image params["data"]["image_key_back"], "back"
		else
			# model.update_attributes image_key: params["data"]["image_key"]
			model.save_and_process_image params["data"]["image_key"], "front"
			# ImageProcesserWorker.perform_async model.class, model.id, params["data"]["image_key"], "front"

		end
		
		render nothing: true
	end

	def delete_image
		model = params["model_name"].constantize.find(params["model_id"])
		if model.image.present? && model.user_id == current_user.id
			if params["side"] == "front"
				model.remove_image!
			else
				model.remove_image_back!
			end
			model.save!
		end
		render nothing: true
	end

	private

	def get_quiz
		@quiz = Quiz.find(params[:id])
	end
end



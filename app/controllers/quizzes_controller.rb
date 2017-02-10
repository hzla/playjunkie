class QuizzesController < ApplicationController
	before_filter :require_signin, except: [:index, :show, :trending, :browse]
	before_filter :get_quiz, only: [:show, :edit, :update, :destroy]

	def index
	end

	def new
		@footer = false
		@quiz_type = params[:quiz_type]
		render "new_#{@quiz_type}"
	end

	def show
		@quiz = Quiz.find params[:id]
		@quiz_type = @quiz.quiz_type
		@page = params[:page] ? params[:page].to_i : 1
		@item = @quiz.quiz_items.order(:order)[@page - 1]
		@quiz.increment_view_count
	end

	def trending
		@page = params[:page] ? params[:page].to_i : 1
		@quizzes = Quiz.trending @page
	end

	def browse 
		@page = params[:page] ? params[:page].to_i : 1
		@editors_picks = Quiz.editors_picks(params[:quiz_type])
		@quiz_type = params[:quiz_type] 
		@quizzes = Quiz.get_collection_of_type @page, @quiz_type
	end

	def edit
		@footer = false
		@quiz = Quiz.find params[:id]
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
			@quiz.update_attributes published: true, publish_date: Time.now
			render "create" and return
		else
			redirect_to user_path(current_user)
		end
	end

	def create
		@quiz = Quiz.create_self_and_all_items params, current_user

		if params[:action_type] == "preview-quiz" #if previewing quiz
			@quiz.update_attributes is_preview?: true 
			redirect_to quiz_path(@quiz) and return
		elsif params[:action_type] == "publish-quiz" #if publishing quiz
			@quiz.update_attributes published: true, publish_date: Time.now
			render "create" and return
		else # if editing quiz
			redirect_to user_path(current_user)
		end
	end

	def destroy
		@quiz.destroy if current_user == @quiz.user
		redirect_to user_path(current_user)
	end

	private

	def get_quiz
		@quiz = Quiz.find(params[:id])
	end
end
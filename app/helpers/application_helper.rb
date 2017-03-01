module ApplicationHelper

	def new_trivia_path
		"/quizzes/new/trivia"
	end

	def new_quiz_quiz_path
		"/quizzes/new/quiz"
	end

	def new_flipcard_path
		"/quizzes/new/flipcard"
	end

	def new_list_path
		"/quizzes/new/list"
	end

	def profile_pic(user)
		if user.profile_pic_url
			user.profile_pic_url
		else
			image_path("missing-user-photo.svg")
		end
	end

	def format_date date
		(date - 8.hours).strftime("%B %-d, %Y at %I:%M%P")
	end

	def format_date_simple date
		(date - 8.hours).strftime("%B %-d, %Y")
	end

	def random_quiz
		if session[:seen_lists] == nil
			session[:seen_lists] = [0]
		end
		quiz = Quiz.all.where(quiz_type: "list", is_preview?: nil, published: true).where('id not in (?)', session[:seen_lists]).shuffle.first
		if !quiz
			session[:seen_lists] = [0]
			quiz = Quiz.all.where(quiz_type: "list", is_preview?: nil, published: true).where('id not in (?)', session[:seen_lists]).shuffle.first
		end
		session[:seen_lists] << quiz.id
		quiz
	end
end

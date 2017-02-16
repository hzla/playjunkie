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
end

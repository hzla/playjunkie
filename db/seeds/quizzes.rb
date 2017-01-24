


10.times do 

	["trivia"].each do |type|
		quiz = Quiz.create title: Faker::Lorem.sentence, description: Faker::Lorem.paragraph, completion_message: Faker::Lorem.paragraph, published: true, user_id: User.first.id, quiz_type: type
		
		
			result_1 = Result.create quiz_id: quiz.id, result_text: Faker::Lorem.sentence, image_credit: Faker::Lorem.sentence, quiz_id: quiz.id, range_min: 0, range_max: 1
			result_2 = Result.create quiz_id: quiz.id, result_text: Faker::Lorem.sentence, image_credit: Faker::Lorem.sentence, quiz_id: quiz.id, range_min: 2, range_max: 3
			result_3 = Result.create quiz_id: quiz.id, result_text: Faker::Lorem.sentence, image_credit: Faker::Lorem.sentence, quiz_id: quiz.id, range_min: 4, range_max: 4
		


		5.times do 
			quiz_item = QuizItem.create title: Faker::Lorem.sentence, image_credit: Faker::Lorem.sentence, image_credit_back: Faker::Lorem.sentence, item_text: Faker::Lorem.paragraph, item_text_back: Faker::Lorem.paragraph, quiz_id: quiz.id
			3.times do 
				ItemAnswer.create answer_text: Faker::Lorem.sentence, image_credit: Faker::Lorem.sentence, quiz_item_id: quiz_item.id
			end
			ItemAnswer.create answer_text: Faker::Lorem.sentence, image_credit: Faker::Lorem.sentence, quiz_item_id: quiz_item.id, correct?: true
		end
	end

	["personality"].each do |type|
		quiz = Quiz.create title: Faker::Lorem.sentence, description: Faker::Lorem.paragraph, completion_message: Faker::Lorem.paragraph, published: true, user_id: User.first.id, quiz_type: type

		result_1 = Result.create quiz_id: quiz.id, result_text: Faker::Lorem.sentence, image_credit: Faker::Lorem.sentence, quiz_id: quiz.id
		result_2 = Result.create quiz_id: quiz.id, result_text: Faker::Lorem.sentence, image_credit: Faker::Lorem.sentence, quiz_id: quiz.id
		result_3 = Result.create quiz_id: quiz.id, result_text: Faker::Lorem.sentence, image_credit: Faker::Lorem.sentence, quiz_id: quiz.id
		results = [result_1, result_2, result_3]


		5.times do 
			quiz_item = QuizItem.create title: Faker::Lorem.sentence, image_credit: Faker::Lorem.sentence, image_credit_back: Faker::Lorem.sentence, item_text: Faker::Lorem.paragraph, item_text_back: Faker::Lorem.paragraph, quiz_id: quiz.id
			(0..2).to_a.each do |n| 
				ItemAnswer.create answer_text: Faker::Lorem.sentence, image_credit: Faker::Lorem.sentence, quiz_item_id: quiz_item.id, result_id: results[n].id
			end
		end
	end

	["flipcard"].each do |type|
		quiz = Quiz.create title: Faker::Lorem.sentence, description: Faker::Lorem.paragraph, completion_message: Faker::Lorem.paragraph, published: true, user_id: User.first.id, quiz_type: type
		
		5.times do 
			quiz_item = QuizItem.create title: Faker::Lorem.sentence, image_credit: Faker::Lorem.sentence, image_credit_back: Faker::Lorem.sentence, item_text: Faker::Lorem.paragraph, item_text_back: Faker::Lorem.paragraph, quiz_id: quiz.id
		end
	end

	["list"].each do |type|
		quiz = Quiz.create title: Faker::Lorem.sentence, description: Faker::Lorem.paragraph, completion_message: Faker::Lorem.paragraph, published: true, user_id: User.first.id, quiz_type: type
		
		5.times do 
			quiz_item = QuizItem.create title: Faker::Lorem.sentence, image_credit: Faker::Lorem.sentence, image_credit_back: Faker::Lorem.sentence, item_text: Faker::Lorem.paragraph, item_text_back: Faker::Lorem.paragraph, quiz_id: quiz.id
		end
	end
end
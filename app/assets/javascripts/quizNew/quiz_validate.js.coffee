QuizValidate = #Validation for creating/editing quizzes goes here
	init: ->
		$('body').on 'submit', '#new_quiz, .edit_quiz', @validateFields if $('.flipcard-oriented-quiz').length < 1
		$('body').on 'click', '#submit-bar .btn', @submitQuiz

#refactor plan
	#flag every problem field
	#use one method to highlight every flagged field instead of a million conditionals
	#split up validation for question/item/answer/result
	#split of different types of validtion checks presence/error


	validateFields: ->
		return true if $('.quiz-submit-action').val() == "save-quiz"
		missingFieldError = false
		incorrectNumberofAnswers = false
		listItemError = false
		flipCardError = false

		############################# MAIN INFO #####################################
		
		quizTitle = ($('#quiz_title').val() != "")
		quizDescription = ($('#quiz_description').val() != "")
		quizImage = ($('#quiz-image-input').val() != "")
		
		if !quizTitle
			$('#quiz_title').css('border', '1px solid red') 
		else
			$('#quiz_title').attr('style', '')

		if !quizDescription
			$('#quiz_description').css('border', '1px solid red') 
		else
			$('#quiz_description').attr('style', '')

		if !quizImage
			$('#quiz-image-input').parent().find('.image-input-overlay').css('border', '1px solid red')
		else
			$('#quiz-image-input').parent().find('.image-input-overlay').attr('style', '')
		
		quizImage = true if $('.quiz-edit').length > 0

		if !quizTitle or !quizDescription or !quizImage
			missingFieldError = true

		############################## QUIZ ITEMS  ######################## 

		$('.question:visible .item-order').each (i) -> #set item order
			$(@).val(i + 1)

		for i in [0..$('.question').length - 1] #validate each question
			question = $($('.question')[i])
			image = question.find('.question-image-preview')
			text = question.find('.question-text')

			## for all items ######################################################
			if text.val() == "" && image.attr('src') == "#"
				if $(".list-quiz").length < 1
					text.css('border', '1px solid red') if text.val() == "" 
					question.find('div.question-image-input').css('border', '1px solid red') if image.attr('src') == "#"
					missingFieldError = true 
			else
				text.attr('style', '')
				question.find('div.question-image-input').attr('style', '')
			
			
			################################# for Lists ###########################
			if $(".list-quiz").length > 0
				description = question.find('.item-description')
				if text.val() == "" && image.attr('src') == "#" && description.val() == "" 
					text.attr('style', '')
					question.find('div.question-image-input').attr('style', '')
					question.css('border', '1px solid red')
					listItemError = true
				else
					question.css('border', 'none')

			################################# for Flipcards ###########################

			if $('.flipcard-quiz').length > 0
				textFront = question.find('.front .card-text-input')
				textBack = question.find('.back .card-text-input')
				imageFront = question.find('.front .image-preview')
				imageBack = question.find('.back .image-preview')

				#Both the Front card and Back card need to have text or an image.

				if textFront.val() == "" && imageFront.attr('src') == "#" || textBack.val() == "" && imageBack.attr('src') == "#"
					text.attr('style', '')
					question.find('div.question-image-input').attr('style', '')
					flipCardError = true

					if textFront.val() == "" && imageFront.attr('src') == "#" 
						$('.front-side').css('border', '1px solid red')
					else
						$('.front-side').css('border', 'none')

					if textBack.val() == "" && imageBack.attr('src') == "#" 
						$('.back-side').css('border', '1px solid red')
					else
						$('.back-side').css('border', 'none')
				else
					$('.front-side, .back-side, .question').css('border', 'none')
			
			#################################### ANSWERS  ###############################

			correctAnswersCount = 0
			question.find('.form-answer').each -> #validate answer fields
				if $(@).find("input[type='checkbox']:checked").length > 0
					correctAnswersCount += 1

				image = $(@).find('.answer-image-preview')
				text = $(@).find('.answer-text-input')
				if $(@).find('.image-input:visible').length > 0 #if image style
					if image.attr('src') == "#" && text.val() == ""
						text.css('border', '1px solid red') if text.val() == "" 
						$(@).find('.image-input').css('border', '1px solid red') if image.attr('src') == "#" 
						missingFieldError = true
					else 
						text.attr('style', '')
						$(@).find('.image-input').attr('style', '')
				else 
					if text.val() == ""
						text.css('border', '1px solid red')
						missingFieldError = true
					else
						text.attr('style', '')

				if $(@).find('select').length > 0 #if this is a personality quiz
					if $(@).find('select').val() == null
						missingFieldError = true
						$(@).find('select').css 'border', '1px solid red'
					else
						$(@).find('select').attr('style', "")


			if $('.trivia-oriented-quiz').length > 0
				if correctAnswersCount != 1
					incorrectNumberofAnswers = true
					question.css('border', '1px solid red')
				else
					question.attr('style', '')
			else
				incorrectNumberofAnswers  = false

		$('.form-result').each ->
			text = $(@).find('.result-text-input')
			image = $(@).find('.result-image-preview')
			if text.val() == "" && image.attr('src') == "#"
				text.css('border', '1px solid red') if text.val() == "" 
				$(@).find('.image-input').css('border', '1px solid red') if image.attr('src') == "#"
				missingFieldError = true
			else
				text.attr('style', '')
				$(@).find('.image-input').attr('style', '')

		if missingFieldError
			$('#missing-field-error').show() 
		else
			$('#missing-field-error').hide()
		if incorrectNumberofAnswers
			$('#correct-answer-error').show() 
		else
			$('#correct-answer-error').hide() 

		if flipCardError
			$('#flipcard-error').show() 
		else
			$('#flipcard-error').hide() 

		if listItemError
			$('#list-item-error').show()
		else
			$('#list-item-error').hide()


		console.log !missingFieldError && !incorrectNumberofAnswers && !listItemError && !flipCardError	
		
		return !missingFieldError && !incorrectNumberofAnswers && !listItemError && !flipCardError	

	submitQuiz: ->
		action = $(@).attr('id')
		$(@).parents("#submit-bar").find('.quiz-submit-action').val action

		if action == 'save-quiz'
			$('#new_quiz, .edit_quiz').submit()
			return
		

		valid = QuizValidate.validateFields()
		if !valid
			return
		
		if action == 'preview-quiz'
			$('#new_quiz, .edit_quiz').attr('target', '_blank')
		else
			$('#new_quiz, .edit_quiz').attr('target', '')
		
		$('#new_quiz, .edit_quiz').submit()

ready = ->
	QuizValidate.init()
# $(document).ready ready
$(document).on 'turbolinks:load', ready
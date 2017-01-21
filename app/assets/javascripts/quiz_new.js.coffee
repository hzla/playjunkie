QuizNew =
	init: ->
		$('body').on 'change', "input[type='file']", @showImagePreview
		$('body').on 'click', '.answer-format', @selectAnswerFormat
		$('body').on 'click', '#add-question', @addQuestion
		$('body').on 'click', '.close-question', @closeQuestion
		$('body').on 'click', '.add-answer', @addAnswer
		$('body').on 'click', '.close-answer', @closeAnswer
		$('body').on 'click', '.add-result', @addResult
		$('body').on 'click', '.close-result', @closeResult



		@displayClosers()

		@questionCount = 1


	addResult: ->
		lastResult = $('.form-result:visible').last()

		newResult = lastResult.clone()
		newResult.find('input, textarea').val("")
		newResult.find('.image-preview').attr('src', '#').hide()

		resultCount = $('.form-result:visible').length
		incrementedResult = newResult.html().replace(///result_#{resultCount}///g, "result_#{resultCount + 1}")
		lastResult.after(lastResult.clone())
		$('.form-result:visible').last().html(incrementedResult)

		$('.close-result').show()

		if $('.form-result:visible').length == $('.question:visible').length
			$(@).hide()

	closeResult: ->
		form = $(@).parents('.new_quiz')
		result = $(@).parent()
		result.addClass('hidden').prependTo(form)
		QuizNew.displayClosers()
		result.find('.result-text-input').val("skip")
		$('.add-result').show()

	addAnswer: ->
		question = $(@).parents('.question')
		lastAnswer = question.find('.form-answer:visible, .text-answer-form:visible').last()

		newAnswer = lastAnswer.clone()

		newAnswer.find('input, textarea').val("").prop('checked', 'true') #reset fields
		newAnswer.find('.image-preview').attr('src', '#').hide() # clear image previews

		answerCount = question.find('.form-answer:visible, .text-answer-form:visible').length
		incrementedAnswer = newAnswer.html().replace(///item_answer_#{answerCount}///g, "item_answer_#{answerCount + 1}")

		lastAnswer.after(lastAnswer.clone())
		question.find('.form-answer:visible, .text-answer-form:visible').last().html(incrementedAnswer)	

		if answerCount == 3
			$(@).hide()

		QuizNew.displayClosers()

	closeAnswer: ->
		question = $(@).parents('.question')
		answer = $(@).parent().addClass('hidden').prependTo(question)
		answer.find('.answer-text-input').val("skip")
		$('.form-answers:visible').find('.add-answer').show()

	displayClosers: ->
		if $('.question:visible').length < 2
			$('.close-question').hide()
		else
			$('.close-question').show()

		$('.question:visible').each ->
			if $('.form-answer:visible, .text-answer-form:visible').length < 2
				$(@).find('.close-answer').hide()
			else
				$(@).find('.close-answer').show()

		if $('.form-result:visible').length < 2
			$('.close-result').hide()
		else
			$('.close-result').show()

	closeQuestion: ->
		confirmation = confirm "Yo you sure?"
		if confirmation
			$(@).parent().hide()
			$(@).parent().find('.box-input').val("skip")
			$('.question-number:visible').each (i) ->
				$(@).text("Question #{i + 1}")
			QuizNew.questionCount -= 1

	addQuestion: ->
		lastQuestion = $('.question:visible').last()
		
		newQuestion = lastQuestion.clone()
		
		newQuestion.find('input, textarea').val("").prop('checked', 'true') #reset fields
		newQuestion.find('.image-preview').attr('src', '#').hide() # clear image previews	
		
		newQuestion.find('.answer-format').hide()
		newQuestion.find('.image-format.selected, .text-format:not(.selected)').show()
		newQuestion.find('.form-answer.image-style').show()
		newQuestion.find('.form-answer.text-style').hide() # reset selected answer format

		incrementedQuestion = newQuestion.html().replace(///quiz_item_#{QuizNew.questionCount}///g, "quiz_item_#{QuizNew.questionCount + 1}").replace("Question #{QuizNew.questionCount}", "Question #{QuizNew.questionCount + 1}") #increment all question numbers

		lastQuestion.after("<div class='form-box question'></div>") #create a container for the next question
		
		$('.question:visible').last().append(incrementedQuestion) #add the next question
		QuizNew.questionCount += 1
		QuizNew.displayClosers()

		$('.add-result').css('display', 'flex') #allow one more result to be added


	selectAnswerFormat: ->
		type = $(@).attr('format_type')
		$(@).parent().find('.selected').hide()
		$(@).parent().find(':not(.selected)').show()
		selected = $(@).parent().find("[format_type='#{type}']:hidden")	
		$(@).hide()
		$(@).parent().find("[format_type='#{type}']").hide()	
		selected.show()

		imageStyleForm = $(@).parents('.form-box').find('.form-answers.image-style')
		textStyleForm = $(@).parents('.form-box').find('.form-answers.text-style')

		if $(@).parent().find('.image-format.selected:visible').length > 0
			imageStyleForm.show()
			textStyleForm.hide()
			textStyleForm.find('input, textarea').val("")
		else
			textStyleForm.show()
			imageStyleForm.hide()
			imageStyleForm.find('input, textarea').val("")



	showImagePreview: -> 
		input = @
		console.log "doing stuff"
		if input.files && input.files[0]
			reader = new FileReader()
			console.log "doinug more stuff"
			reader.onload =  (e) ->
				previewBox = $(input).next()
				previewBox.show()
				previewBox.attr 'src', e.target.result
			reader.readAsDataURL input.files[0]

ready = ->
	QuizNew.init()
$(document).ready ready
# $(document).on 'page:load', ready
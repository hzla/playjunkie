QuizNew =
	init: ->
		$('body').on 'change', "input[type='file']", @showImagePreview
		$('body').on 'click', '.answer-format', @selectAnswerFormat
		$('body').on 'click', '#add-question', @addQuestion
		$('body').on 'click', '.close-question', @closeQuestion
		@displayClosers()

		@questionCount = 1

	displayClosers: ->
		if $('.question:visible').length < 2
			$('.close-question').hide()
		else
			$('.close-question').show()

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
		
		$('.question').last().append(incrementedQuestion) #add the next question
		QuizNew.questionCount += 1
		QuizNew.displayClosers()


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
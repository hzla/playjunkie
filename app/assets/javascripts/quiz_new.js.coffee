QuizNew =
	init: ->
		$('body').on 'change', "input[type='file']", @showImagePreview
		$('body').on 'click', '.close-image', @closeImage
		$('body').on 'click', '.answer-format', @selectAnswerFormat
		$('body').on 'click', '#add-question', @addQuestion
		$('body').on 'click', '.close-question', @closeQuestion
		$('body').on 'click', '.add-answer', @addAnswer
		$('body').on 'click', '.close-answer', @closeAnswer
		$('body').on 'click', '.add-result', @addResult
		$('body').on 'click', '.close-result', @closeResult
		$('body').on 'click', '.move-question', @moveQuestion

		$('body').on 'click', '.color', @chooseColor
		$('body').on 'click', '.add-card-text', @addCardText
		$('body').on 'click', '.side-chooser', @chooseSide
		$('body').on 'keyup', '.text-box', @syncItemText
		@displayClosers()
		@displayMovers()

		@questionCount = 1


	syncResultsRange: ->
		resultsCount = $('.form-result:visible').length
		questionsCount = $('.question:visible').length

		rangeWidth = Math.floor((questionsCount / resultsCount))
		console.log rangeWidth
		ranges = []

		rangeStart = 0
		rangeEnd = rangeWidth
		console.log ranges
		
		for i in [1..resultsCount]
			range = []
			range.push rangeStart
			range.push rangeEnd
			if rangeStart == rangeEnd
				rangeStart += 1
				rangeEnd += 1
			else
				rangeStart += (rangeWidth + 1)
				rangeEnd += (rangeWidth + 1)
			ranges.push range

		questionLimit = questionsCount
		for i in [1..ranges.length]
			if ranges[ranges.length - i][1] > questionLimit
				ranges[ranges.length - i][1] = questionLimit
			if ranges[ranges.length - i][0] > questionLimit
				ranges[ranges.length - i][0] = questionLimit
			questionLimit -= 1

		$('.form-result:visible .results-range').each (i) ->
			$(@).find('.min').text(ranges[i][0])
			$(@).find('.max').text(ranges[i][1])
			if ranges[i][0] == ranges[i][1]
				$(@).find('.min, .hyphen').hide()
			else
				$(@).find('.min, .hyphen').show()



	moveQuestion: ->
		question = $(@).parents('.question')
		if $(@).hasClass('move-down')
			question.insertAfter(question.nextAll('.question:visible').first())
		else
			question.insertBefore(question.prevAll('.question:visible').first())

		$('.question:visible .question-number').each (i) ->
				$(@).find('p').text("#{i + 1}")
		QuizNew.displayMovers()

	displayMovers: ->
		$('.move-question').show()
		$('.question:visible').first().find('.move-up').hide()
		$('.question:visible').last().find('.move-down').hide()
	chooseSide: ->
		card = $(@).parents('.question')
		card.find('.side-chooser').removeClass('selected')
		$(@).addClass('selected')
		
		if $(@).hasClass('choose-front')
			card.find('.flip-container').removeClass('flip')
		else
			card.find('.flip-container').addClass('flip')

	addCardText: ->
		card = $(@).parents('.question-image-input')
		card.find('.text-box')[0].contentEditable = true
		card.find('.text-box').focus()

	syncItemText: ->
		card = $(@).parents('.question-image-input')
		card.find('.card-text-input').val($(@).text())

	chooseColor: ->
		card = $(@).parents('.question-image-input')
		color = $(@).css('background-color')
		card.css('background-color', color)
		card.find('input.question-image-input').val("")
		card.find('.image-preview').attr('src', '#').hide()
		card.find('.card-color-input').val(color)

	addResultChoiceToAnswers: ->
		$('select').each ->
			optionCount = $(@).find('option').length
			$(@).append("<option value='#{optionCount - 1}'>Result #{optionCount}</option>")

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
		if $('.form-result:visible').length == $('.question:visible').length && $('.trivia-oriented-quiz').length > 0
			$(@).hide()

		if $('.result-oriented-quiz').length > 0
			QuizNew.addResultChoiceToAnswers()

		QuizNew.syncResultsRange()
	closeResult: ->
		form = $(@).parents('.new_quiz')
		result = $(@).parent()
		result.addClass('hidden').prependTo(form)
		QuizNew.displayClosers()
		result.find('.result-text-input').val("skip")
		$('.add-result').show()
		QuizNew.syncResultsRange()

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

		if answerCount == 3 && $('.trivia-oriented-quiz').length > 0
			$(@).hide()

		if $('.result-oriented-quiz').length > 0
			if answerCount == 7
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
			$('.question:visible .question-number').each (i) ->
				$(@).find('p').text("#{i + 1}")
			QuizNew.questionCount -= 1
			QuizNew.displayMovers()
			QuizNew.syncResultsRange()

	addQuestion: ->
		lastQuestion = $('.question:visible').last()
		
		newQuestion = lastQuestion.clone()
		

		newQuestion.find('.text-box').text("")
		newQuestion.find('.question-image-input').css('background-color', '')
		
		newQuestion.find('input, textarea').val("").prop('checked', 'true') #reset fields
		newQuestion.find('.image-preview').attr('src', '#').hide() # clear image previews	
		
		newQuestion.find('.answer-format').hide()
		newQuestion.find('.image-format.selected, .text-format:not(.selected)').show()
		newQuestion.find('.form-answer.image-style').show()
		newQuestion.find('.form-answer.text-style').hide() # reset selected answer format

		newQuestion.find('.side-chooser').removeClass('selected')
		newQuestion.find('.flip-container').removeClass('flip')
		newQuestion.find('.choose-front').addClass('selected') #reset card sides

		incrementedQuestion = newQuestion.html().replace(///quiz_item_#{QuizNew.questionCount}///g, "quiz_item_#{QuizNew.questionCount + 1}").replace("<p>#{QuizNew.questionCount}</p>", "<p>#{QuizNew.questionCount + 1}</p>") #increment all question numbers

		lastQuestion.after("<div class='form-box question'></div>") #create a container for the next question
		
		$('.question:visible').last().append(incrementedQuestion) #add the next question
		QuizNew.questionCount += 1
		QuizNew.displayClosers()

		$('.add-result').css('display', 'flex') #allow one more result to be added
		QuizNew.displayMovers()
		QuizNew.syncResultsRange()


	selectAnswerFormat: ->
		type = $(@).attr('format_type')
		$(@).parent().find('.selected').hide()
		$(@).parent().find(':not(.selected)').show()
		selected = $(@).parent().find("[format_type='#{type}']:hidden")	
		$(@).hide()
		$(@).parent().find("[format_type='#{type}']").hide()	
		selected.show()

		form = $(@).parents('.form-box').find('.form-answers')

		if $(@).parent().find('.image-format.selected:visible').length > 0
			form.addClass('image-style').removeClass('text-style')	
		else
			form.removeClass('image-style').addClass('text-style')
		
		form.find('input, textarea').val("")

	showImagePreview: -> 
		input = @
		if input.files && input.files[0]
			reader = new FileReader()
			console.log "doing more stuff"
			reader.onload =  (e) ->
				previewBox = $(input).next()
				previewBox.show()
				previewBox.attr 'src', e.target.result
			reader.readAsDataURL input.files[0]
			$(@).parents('.box-field').find('.close-image').show()

	closeImage: ->
		box = $(@).parents('.box-field')
		box.find('.image-preview').attr('src', '#').hide()
		box.find('input.question-image-input').val("")
		$(@).hide()


ready = ->
	QuizNew.init()
$(document).ready ready
# $(document).on 'page:load', ready
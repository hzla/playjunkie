QuizNew = #UI for creating/editing Quizzes goes here
	init: ->
		@questionCount = $('.question:visible').length

		#Adding and Removing Items
		$('body').on 'change', "input[type='file']", @showImagePreview
		$('body').on 'click', '.close-image', @closeImage
		$('body').on 'click', '#add-question', @addQuestion
		$('body').on 'click', '.close-question', @closeQuestion
		$('body').on 'click', '.add-answer', @addAnswer
		$('body').on 'click', '.close-answer', @closeAnswer
		$('body').on 'click', '.add-result', @addResult
		$('body').on 'click', '.close-result', @closeResult
		$('body').on 'click', '.move-question', @moveQuestion		
		
		#Misc
		$('body').on 'click', '.answer-format', @selectAnswerFormat
		$('body').on 'keyup', '.char-countable input, .char-countable textarea', @showCharsRemaining
		$('body').on 'keypress', '.text-box', @showCharsRemainingForTextbox
		
		#Confirm when User leaves page
		if $('#new_quiz').length > 0
			window.onbeforeunload = @confirmCloseWindow  
		$('body').on 'click', '.btn', ->
			window.onbeforeunload = null
		
		#Make sure everything is properly shown/hidden	
		@showImagePreviews()
		@manageClosers()
		@manageMovers()
		@closeSaveMessage()

	closeSaveMessage: ->
		setTimeout ->
			$('#flash-message').animate
				opacity: 0
			, 400
		, 1500

	confirmCloseWindow: (e) ->
		if $('#new_quiz').length > 0
			e = e || window.event;
			if (e) 
				e.returnValue = 'Sure?'
			return 'Sure?'

	showImagePreviews: ->
		$('.image-preview').show()
		$(".image-preview[src='#'], .image-preview[src='']").hide()

	showCharsRemainingForTextbox: (e) ->
		currentChars = $(@).text().trim().length
		limit = parseInt($(@).attr('maxlength'))
		remaining = limit - currentChars
		$(@).parent().find('.char-count').text remaining
		if remaining == 0
			e.preventDefault()

	showCharsRemaining: ->
		currentChars = $(@).val().length
		limit = parseInt($(@).attr('maxlength'))
		remaining = limit - currentChars
		$(@).parent().find('.char-count').text remaining

	syncResultsRange: ->
		resultsCount = $('.form-result:visible').length
		questionsCount = $('.question:visible').length

		rangeWidth = Math.floor((questionsCount / resultsCount))
		ranges = []

		rangeStart = 0
		rangeEnd = rangeWidth
		#math stuff
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
			$(@).find('.range-min').val(ranges[i][0])
			$(@).find('.range-max').val(ranges[i][1])
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
		QuizNew.manageMovers()

	manageMovers: -> #hide move up for first question and move down for last question
		$('.move-question').show()
		$('.question:visible').first().find('.move-up').hide()
		$('.question:visible').last().find('.move-down').hide()

	addResultChoiceToAnswers: ->
		$('select').each ->
			optionCount = $(@).find('option').length
			$(@).append("<option value='#{optionCount - 1}'>Result #{optionCount}</option>")

	addResult: ->
		lastResult = $('.form-result:visible').last()
		newResult = lastResult.clone()
		resultCount = $('.form-result:visible').length
		incrementedResult = newResult.html().replace(///result_#{resultCount}///g, "result_#{resultCount + 1}")
		lastResult.after(lastResult.clone())
		$('.form-result:visible').last().html(incrementedResult)
		
		newResult = $('.form-result:visible').last()
		newResult.find('input, textarea').val("")
		newResult.find('.image-preview').attr('src', '#').hide()
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
		QuizNew.manageClosers()
		result.find('.result-text-input').val("skip")
		$('.add-result').show()
		QuizNew.syncResultsRange()

	addAnswer: ->
		question = $(@).parents('.question')
		lastAnswer = question.find('.form-answer:visible, .text-answer-form:visible').last()

		newAnswer = lastAnswer.clone()
		newAnswer.find('.image-preview').attr('src', '#').hide() # clear image previews
		newAnswer.find('.close-image').hide()

		answerCount = question.find('.form-answer:visible, .text-answer-form:visible').length
		incrementedAnswer = newAnswer.html().replace(///item_answer_#{answerCount}///g, "item_answer_#{answerCount + 1}")

		lastAnswer.after(lastAnswer.clone())
		question.find('.form-answer:visible, .text-answer-form:visible').last().html(incrementedAnswer)	
		question.find('.form-answer').last().find('input, textarea').val("").prop('checked', 'true')
		question.find("input[type='checkbox']").val("on")

		if answerCount == 3 && $('.trivia-oriented-quiz').length > 0
			$(@).hide()

		if $('.result-oriented-quiz').length > 0
			if answerCount == 7
				$(@).hide()

		QuizNew.manageClosers()

	closeAnswer: ->
		question = $(@).parents('.question')
		answer = $(@).parent().addClass('hidden').prependTo(question)
		answer.find('.answer-text-input').val("skip")
		$('.form-answers:visible').find('.add-answer').show()
		QuizNew.manageClosers()


	manageClosers: -> #hide element closer if only one element
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
		confirmation = confirm "Are you sure you want to delete this question?"
		if confirmation
			$(@).parent().hide()
			$(@).parent().find('.box-input, .card-text-input').val("skip")
			$('.question:visible .question-number').each (i) ->
				$(@).find('p').text("#{i + 1}")
			QuizNew.questionCount -= 1
			QuizNew.manageMovers()
			QuizNew.manageClosers()
			QuizNew.syncResultsRange()

	addQuestion: ->
		lastQuestion = $('.question:visible').last()

		newQuestion = lastQuestion.clone()

		# increment all question numbers in field names
		newQuestion = newQuestion.html().replace(///quiz_item_#{QuizNew.questionCount}///g, "quiz_item_#{QuizNew.questionCount + 1}").replace("<p>#{QuizNew.questionCount}</p>", "<p>#{QuizNew.questionCount + 1}</p>") 
		# create a container for the next question
		lastQuestion.after("<div class='form-box question'></div>")
		# add the next question
		$('.question:visible').last().append(newQuestion) 
		
		newQuestion = $(".question:visible").last()

		#Reset the New Question
		newQuestion.find('.text-box').text("") #clear flipcard text and color
		newQuestion.find('.question-image-input').css('background-color', '')
		
		newQuestion.find('input, textarea').val("").prop('checked', 'true') #reset fields
		newQuestion.find("input[type='checkbox']").val("on")
		newQuestion.find('.image-preview').attr('src', '#').hide() # clear image previews	
		
		newQuestion.find('.answer-format').hide()
		newQuestion.find('.image-format.selected, .text-format:not(.selected)').show()
		newQuestion.find('.form-answer.image-style').show()
		newQuestion.find('.form-answer.text-style').hide() # reset selected answer format
		newQuestion.find('.close-image').hide()

		newQuestion.find('.side-chooser').removeClass('selected')
		newQuestion.find('.flip-container').removeClass('flip')
		newQuestion.find('.choose-front').addClass('selected') #reset card sides

		#TODO figure out why i wrote these 3 lines
		newAnswer = newQuestion.find('.form-answer').first().clone()
		newQuestion.find('.form-answer').remove()
		newQuestion.find('.form-answers').prepend newAnswer
		
		#new Result can be created now that there is one more question
		QuizNew.questionCount += 1 
		$('.add-result').css('display', 'flex') 
		
		#Update UI elements
		QuizNew.manageClosers()
		QuizNew.manageMovers()
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
			reader.onload =  (e) ->
				previewBox = $(input).next()
				console.log previewBox
				previewBox.show()
				$(previewBox).css('background-image', "url(#{e.target.result})")
				previewBox.attr 'src', e.target.result
			
			reader.readAsDataURL input.files[0]
			$(@).parent().find('.close-image').show()

	closeImage: ->
		box = $(@).parent()
		box.find('.image-preview').attr('src', '#').hide()
		box.find("input[type='file']").val("")
		$(@).hide()

ready = ->
	QuizNew.init()
$(document).on 'turbolinks:load', ready
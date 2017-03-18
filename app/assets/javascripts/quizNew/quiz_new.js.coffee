QuizNew = #UI for creating/editing Quizzes goes here
	init: ->
		@questionCount = $('.question').length

		#Adding and Removing Items
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
		@setAnswerFormats()
		@syncResultsRange()

	closeSaveMessage: ->
		setTimeout ->
			$('#flash-message').animate
				opacity: 0
			, 400
		, 2500

	confirmCloseWindow: (e) ->
		if $('#new_quiz').length > 0
			e = e || window.event;
			if (e) 
				e.returnValue = 'Sure?'
			return 'Sure?'

	showImagePreviews: ->
		$('.image-preview').show()
		$(".image-preview[src='blank'], .image-preview[src='']").hide()

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
		resultsCount = $('.form-result').length
		questionsCount = $('.question').length

		if resultsCount >= questionsCount
			$('.add-result').hide()

		rangeWidth = Math.floor((questionsCount / resultsCount))
		ranges = []

		rangeStart = 0
		rangeEnd = rangeWidth
		# math stuff
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
			y = $(window).scrollTop()
			question.insertBefore(question.prevAll('.question:visible').first())
			$(window).scrollTop(y);

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
			$(@).append("<option value='#{optionCount - 1}' class='result-#{optionCount}'>Result #{optionCount}</option>")

	addResult: ->
		lastResult = $('.form-result:visible').last()
		quizId = $('.edit_quiz').attr('quiz_id')
		quizType = $('#quiz_type').val()

		$.post "/quizzes/#{quizId}/results?i=#{$('.form-result').length}&quiz_type=#{quizType}", (data) ->
			$('.form-result:visible').last().after(data)
			$('.close-result').show()
		
			# number of results can't exceed number of questions for trivia quizzes
			if $('.form-result:visible').length == $('.question:visible').length && $('.trivia-oriented-quiz').length > 0
				$(@).hide()

			# add another choice for answers for quiz type quizzes
			if $('.quiz-oriented-quiz').length > 0
				QuizNew.addResultChoiceToAnswers()
			QuizNew.syncResultsRange()
	
	closeResult: ->
		result = $(@).parent()
		resultNumber = result.index()	
		
		$.ajax
			method: "DELETE",
			url: "/results/#{result.attr("model_id")}"
			success: ->
				result.remove()
				$('.add-result').show()
				QuizNew.manageClosers()

				if $('.quiz-oriented-quiz').length > 0
					QuizNew.removeResultChoice(resultNumber)
				QuizNew.syncResultsRange()

	removeResultChoice: (index) ->
		$('select').each ->
			if parseInt($(@).val()) == index
				$(@).val(-1)
			$($(@).find('option')[index + 1]).remove()

		$('select').each ->
			$(@).find('option').each (i) ->
				unless i == 0
					$(@).val(i - 1)
					$(@).text("Result #{i}")

	addAnswer: ->
		question = $(@).parents('.question')
		lastAnswer = question.find('.form-answer:visible, .text-answer-form:visible').last()
		quizItemId = question.attr('model_id')
		itemNumber = question.attr('item_number')
		quizType = $('#quiz_type').val()
		i = question.find('.form-answer:visible, .text-answer-form:visible').length + 1
		$.post "/quiz_items/#{quizItemId}/answers?item_number=#{itemNumber})}&i=#{i}&quiz_type=#{quizType}", (data) ->
			lastAnswer.after(data)

			# hide add answer at 4 answers if trivia quiz
			$(@).hide() if i == 4 && $('.trivia-oriented-quiz').length > 0
			# hide add answer at 4 answers if quiz quiz
			$(@).hide() if i == 8 && $('.quiz-oriented-quiz').length > 0 
			QuizNew.manageClosers()

	closeAnswer: ->
		question = $(@).parents('.question')
		answer = $(@).parent()
		$.ajax
			method: "DELETE",
			url: "/item_answers/#{answer.attr("model_id")}"
			success: ->
				answer.remove()
				question.find('.add-answer').show()
				QuizNew.manageClosers()

	manageClosers: -> #hide element closer if only one element
		if $('.question:visible').length < 2
			$('.close-question').hide()
		else
			$('.close-question').show()

		$('.question:visible').each -> 
			if $(@).find('.form-answer:visible, .text-answer-form:visible').length < 2
				$(@).find('.close-answer').hide()
			else
				$(@).find('.close-answer').show()

		$('.close-image').each ->
			imgPreview = $(@).parent().children('.image-preview')
			if imgPreview.css('background-image').includes "amazonaws"
				$(@).show()

		if $('.form-result:visible').length < 2
			$('.close-result').hide()
		else
			$('.close-result').show()

	closeQuestion: ->
		confirmation = confirm "Are you sure you want to delete this question?"
		if confirmation
			question = $(@).parent()
			$.ajax
				method: "Delete",
				url: "/quiz_items/#{question.attr("model_id")}"
				success: ->
					question.remove()
					$('.question:visible .question-number').each (i) ->
						$(@).find('p').text("#{i + 1}")
					QuizNew.questionCount -= 1
					QuizNew.manageMovers()
					QuizNew.manageClosers()
					QuizNew.syncResultsRange()

	addQuestion: ->
		quizId = $('.edit_quiz').attr('quiz_id')
		quizType = $('#quiz_type').val()
		#create a new quiz item and get view for it
		$.post "/quizzes/#{quizId}/quiz_items?i=#{$('.question').length}&quiz_type=#{quizType}",  (data) ->
			$('.question:visible').last().after(data)
		#new Result can be created now that there is one more question
			QuizNew.questionCount += 1 
			# $('.question:visible').last().find('.question-number p').text QuizNew.questionCount
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
		
		$(@).parents('.question').find('.answer-format').val($(@).attr('format_type'))

	setAnswerFormats: ->
		$('input.answer-format').each ->
			if $(@).val() == "image"
				$(@).parents('.question').find('.image-format').click()
			else
				$(@).parents('.question').find('.text-format').click()

ready = ->
	QuizNew.init()
$(document).on 'ready', ready
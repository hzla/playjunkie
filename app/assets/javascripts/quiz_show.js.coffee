QuizShow =
	init: ->
		@score = 0
		@resultScores = {}
		$('body').on 'click', '.trivia .answer:not(.unselectable)', @chooseTriviaAnswer
		$('body').on 'click', '.personality .answer', @choosePersonalityAnswer
		$('body').on 'click', '.flipcard .image-container', @flipCard

	flipCard: ->
		$(@).parents('.flip-container').toggleClass('flip')

	choosePersonalityAnswer: ->
		answers = $(@).parent()
			
		currentResultId = parseInt($(@).attr('result-id')) #get the result id that this answer boosts
		
		answers.find('.answer').each ->
			resultId = parseInt($(@).attr('result-id'))
			if QuizShow.resultScores[resultId]
				if $(@).hasClass('selected')
					$(@).removeClass('selected')
					QuizShow.resultScores[resultId] -= 1
			else
				QuizShow.resultScores[resultId] = 0 #reset all result boosts for this question
		
		QuizShow.resultScores[currentResultId] += 1 #boost the result for this answer
		
		$(@).addClass('selected') #select choice
		$(@).parents('.item').addClass('answered')
		QuizShow.checkForResultDisplay()
			

	checkForResultDisplay: ->
		if $('.item:not(.answered)').length < 1
			$(".result[result-id='#{QuizShow.currentHighestResult()}']").show()


	currentHighestResult: ->
		Object.keys(QuizShow.resultScores).reduce (a, b) ->
			if QuizShow.resultScores[a] > QuizShow.resultScores[b]
				a
			else
				b

	chooseTriviaAnswer: ->
		answers = $(@).parent()
		if $(@).hasClass('correct') && !$(@).hasClass('unselectable')
			QuizShow.score += 1
		else
			answers.find('.correct').addClass('selected')
		answers.find('.answer').addClass('unselectable')
		$(@).addClass('selected')
		
		if $('.answer:not(.unselectable)').length < 1
			QuizShow.showResult()

	showResult: ->
		score = QuizShow.score
		$('.result').each ->
			if score >= parseInt($(@).attr('range-min')) and score <= parseInt($(@).attr('range-max'))
				$(@).show() 
		$('.score-number').text(score)


ready = ->
	QuizShow.init()
# $(document).ready ready
$(document).on 'turbolinks:load', ready
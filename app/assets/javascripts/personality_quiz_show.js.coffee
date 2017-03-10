PQuizShow =
	init: ->
		$('body').on 'click', '.starter-btn', @startPQuiz
		$('body').on 'click', '.content-container.quiz .answer', @answerPQuiz
		$('body').on 'click', '.nav-back', @navBack

	navBack: ->
		current = $('.item:visible').first()
		prev = current.prev()

		$($('.nav-numbers li')[prev.index() + 1]).removeClass('selected')
		if current.index() != 0
			current.animate 
				opacity: 0
			, 400, ->
				current.hide()
				prev.show().animate({opacity: 1}, 400)

	startPQuiz: ->
		$(@).parents('.quiz-starter').animate 
			opacity: 0
		, 400, ->
			$(@).hide()
			$('.item').first().show().animate({opacity: 1}, 400)
			$('.quiz-navigator').removeClass('hidden').animate({opacity: 1}, 400)

	answerPQuiz: ->
		current = $(@).parents('.item')
		currentNum = current.index()
		$($('.nav-numbers li')[currentNum + 1]).addClass('selected')
		next = current.next()
		current.animate 
			opacity: 0
		, 400, ->
			current.hide()
			next.show().animate({opacity: 1}, 400)
			if next.length == 0
				$('.quiz-navigator').hide()

ready = ->
	PQuizShow.init()
$(document).ready ready
# $(document).on 'turbolinks:load', ready
QuizShow =
	init: ->
		@score = 0
		$('body').on 'click', '.answer:not(.unselectable)', @chooseCorrectAnswer

	chooseCorrectAnswer: ->
		answers = $(@).parent()
		if $(@).hasClass('correct') && !$(@).hasClass('unselectable')
			QuizShow.score += 1
		else
			answers.find('.correct').addClass('selected')
		answers.find('.answer').addClass('unselectable')
		$(@).addClass('selected')
		


ready = ->
	QuizShow.init()
# $(document).ready ready
$(document).on 'turbolinks:load', ready
QuizIndex =
	init: ->
		$('body').on 'click', '#load-more', @loadMore


	loadMore: ->
		$.get '/quizzes/featured', (data) -> 
			# console.log data
			$('.quizzes-section.list-view').append(data)


ready = ->
	QuizIndex.init()
# $(document).ready ready
$(document).on 'turbolinks:load', ready
QuizIndex =
	init: ->
		$('body').on 'click', '#load-more', @loadMore


	loadMore: ->
		$.get '/quizzes/featured', (data) -> 
			$('.quizzes-section.list-view').html(data)


ready = ->
	QuizIndex.init()
# $(document).ready ready
$(document).on 'turbolinks:load', ready
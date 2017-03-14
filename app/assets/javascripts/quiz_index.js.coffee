QuizIndex =
	init: ->
		$('body').on 'click', '#load-more', @loadMore
		@formatAds()

	formatAds: ->
		$('.bottom-ad').each ->
			$(@).find('iframe').attr('width', '180').attr('height', '150')


	loadMore: ->
		offset = $('.quiz-list-item').length
		$.get "/quizzes/featured?offset=#{offset}", (data) -> 
			$('#load-more').before(data)
			if $(data).find('.quiz-list-item').length < 10
				$('#load-more').hide()


ready = ->
	QuizIndex.init()
$(document).ready ready
# $(document).on 'turbolinks:load', ready
QuizSort =
	init: ->
		$('body').on 'click', '.sort-bar p:not(.label)', @chooseSortOption
		$("p.selected").click()

	chooseSortOption: ->
		$(@).parents().find('p').removeClass('selected')
		$(@).addClass('selected')

		quizzes = $('.sortable .sort-item')
		quizzes.sort(QuizSort.sortByOption($(@).attr('sort-name')))

		for i in [0..quizzes.length - 1]
			console.log i
			quizzes[i].parentNode.appendChild(quizzes[i])

	sortByOption: (sortName) ->
		if sortName == "pd"
			QuizSort.sortByPublishDate
		else if sortName == "cd"
			QuizSort.sortByCreationDate
		else if sortName == "vc"
			QuizSort.sortByPopularity
		else
			QuizSort.sortByName


	sortByPopularity: (a, b) ->
		$(b).attr('view_count').localeCompare($(a).attr('view_count'))

	sortByPublishDate: (a, b) ->
		$(b).attr('publish_date').localeCompare($(a).attr('publish_date'))

	sortByCreationDate: (a, b) ->
		$(b).attr('creation_date').localeCompare($(a).attr('creation_date'))

	sortByName: (a, b) ->
		$(a).find('.quiz-title').text().localeCompare($(b).find('.quiz-title').text())



ready = ->
	QuizSort.init()
# $(document).ready ready
$(document).on 'turbolinks:load', ready
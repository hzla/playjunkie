Header =
	init: ->
		$('body').on 'click', '#menu-icon', @toggleMenuOnClick

	toggleMenuOnClick: ->
		$('#nav-dropdown').show()
		$('body').addClass('dropdown-showing')
		

ready = ->
	Header.init()
$(document).ready ready
# $(document).on 'page:load', ready
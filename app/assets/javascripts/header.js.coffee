Header =
	init: ->
		$('body').on 'click', '#menu-icon', @toggleMenuOnClick
		$('body').on 'click', '#close-dropdown', @toggleMenuOnClick

	toggleMenuOnClick: ->
		$('#nav-dropdown').toggle()


		

ready = ->
	Header.init()
$(document).ready ready
# $(document).on 'page:load', ready
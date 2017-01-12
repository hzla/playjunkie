Header =
	init: ->
		$('body').on 'click', '#close-dropdown, #menu-icon', @toggleMenuOnClick
		# $('.body').on 'cick', ''


	toggleMenuOnClick: ->
		$('#nav-dropdown').toggle()

ready = ->
	Header.init()
$(document).ready ready
# $(document).on 'page:load', ready
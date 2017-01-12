Header =
	init: ->
		$('body').on 'click', '#close-dropdown, #menu-icon', @toggleMenuOnClick
		$('body').on 'mouseenter', '#nav-profile-pic', @showProfileDropdown
		$('body').on 'mouseleave', '#profile-dropdown', @closeProfileDropdown

	toggleMenuOnClick: ->
		$('#nav-dropdown').toggle()

	showProfileDropdown: ->
		$('#profile-dropdown').show()

	closeProfileDropdown: ->
		$('#profile-dropdown').hide()

ready = ->
	Header.init()
$(document).ready ready
# $(document).on 'page:load', ready
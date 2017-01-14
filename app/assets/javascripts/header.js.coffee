Header =
	init: ->
		console.log "init"
		$('body').on 'click', '#close-dropdown, #menu-icon', @toggleMenuOnClick
		$('body').on 'mouseenter', '#nav-profile-pic', @showProfileDropdown
		$('body').on 'mouseleave', '#profile-dropdown', @closeProfileDropdown

	toggleMenuOnClick: ->
		$('#nav-dropdown').toggle()

	showProfileDropdown: ->
		$('#profile-dropdown').show()
		console.log "trigger"

	closeProfileDropdown: ->
		$('#profile-dropdown').hide()

ready = ->
	Header.init()
# $(document).ready ready
$(document).on 'turbolinks:load', ready
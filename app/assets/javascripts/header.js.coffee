Header =
	init: ->
		console.log "init"
		$('body').on 'click', '#close-dropdown, #menu-icon', @toggleMenuOnClick
		$('body').on 'mouseenter', '#nav-profile-pic', @showProfileDropdown
		$('body').on 'mouseleave', '#profile-dropdown', @closeProfileDropdown

		$('body').on 'mouseenter', '#create-btn', @showCreationDropdown
		$('body').on 'mouseleave', '#creation-dropdown', @closeCreationDropdown

	toggleMenuOnClick: ->
		$('#nav-dropdown').toggle()

	showProfileDropdown: ->
		$('#profile-dropdown').show()
		$('#creation-dropdown').hide()

	closeProfileDropdown: ->
		$('#profile-dropdown').hide()

	showCreationDropdown: ->
		$('#creation-dropdown').css('display', 'flex')
		$('#profile-dropdown').hide()

	closeCreationDropdown: ->
		$('#creation-dropdown').hide()

ready = ->
	Header.init()
# $(document).ready ready
$(document).on 'turbolinks:load', ready
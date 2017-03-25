Header =
	init: ->
		$('body').on 'click', '#close-dropdown, #menu-icon', @toggleMenuOnClick
		$('body').on 'mouseenter', '#nav-profile-pic', @showProfileDropdown
		$('body').on 'mouseleave', '#profile-dropdown', @closeProfileDropdown

		$('body').on 'mouseenter', '#create-btn', @showCreationDropdown
		$('body').on 'mouseleave', '.creation-dropdown', @closeCreationDropdown

		$('body').on 'mouseenter', '.fun-dropdown-trigger', @showFunDropdown
		$('body').on 'mouseleave', '.fun-dropdown', @closeFunDropdown

		$('body').on 'click', '#search-icon', @openSearch

		$('body').on 'mouseenter', '#get-started', @showCreationDropdown

	openSearch: ->
		$('.search-input').toggle()
		$('#logo').toggle()

	toggleMenuOnClick: ->
		$('#nav-dropdown').toggle()

	showProfileDropdown: ->
		$('#profile-dropdown').show()
		$('.creation-dropdown').removeClass('shown-flexed')

		check = setInterval ->
			if $('#profile-dropdown:hover').length < 1 && $('#nav-profile-pic:hover').length < 1 && $('.bridge:hover').length < 1 && $('#get-started:hover').length < 1
				$('#profile-dropdown').hide()
		, 1000

	closeProfileDropdown: ->
		$('#profile-dropdown').hide()

	showCreationDropdown: ->
		btn = $(@)
		btn.parent().find('.creation-dropdown').addClass('shown-flexed')
		$('#profile-dropdown').hide()

		check = setInterval ->
			if $('.creation-dropdown:hover').length < 1 && $('#create-btn:hover').length < 1 && $('.bridge:hover').length < 1 && $('#get-started:hover').length < 1
				btn.parent().find('.creation-dropdown').removeClass('shown-flexed')
		, 500


	closeCreationDropdown: ->
		$('.creation-dropdown').removeClass('shown-flexed')

	showFunDropdown: ->
		$('.fun-dropdown').show()

		check = setInterval ->
			if $('.fun-dropdown:hover').length < 1 && $('.fun-dropdown-trigger:hover').length < 1 && $('.bridge:hover').length < 1
				$('.fun-dropdown').hide()
		, 1000

	closeFunDropdown: ->
		$('.fun-dropdown').hide()

ready = ->
	Header.init()
$(document).ready ready
# $(document).on 'turbolinks:load', ready
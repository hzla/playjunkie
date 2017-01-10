Header =
	init: ->
		$('body').on 'click', '#menu-icon', @toggleMenuOnClick
		$('body').on 'click', '#close-dropdown', @toggleMenuOnClick
		$('body').on 'click', '.signinup', @openSignIn
		$('body').on 'click', '.signup-link', @toggleSigninSignUp

	openSignIn: ->
		Header.toggleMenuOnClick()
		$('.signin-container').show()
		window.location = "##{$('.signin-header:visible').text()}"

	toggleMenuOnClick: ->
		$('#nav-dropdown').toggle()

	toggleSigninSignUp: ->
		$('.signin-content').toggle()
		window.location = "##{$('.signin-header:visible').text()}"




		

ready = ->
	Header.init()
$(document).ready ready
# $(document).on 'page:load', ready
Email =
	init: ->
		$('body').on 'ajax:success', '#password-reset, .send-email', @showSent
		$('body').on 'submit', '.send-email', @showSending


	showSent: (e, data) ->
		$('.form-message').attr('style','').show().text(data.message)
		setTimeout ->
			$('.form-message').animate 
				opacity: 0
			, 400
			if data.redirect
				location.href = data.redirect
		, 1000

	showSending: (e, data) ->
		$('.form-message').attr('style','').show().text("Sending...")






ready = ->
	Email.init()
# $(document).ready ready
$(document).on 'turbolinks:load', ready
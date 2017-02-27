SocialMedia =
	init: ->
		$('body').on 'click', '.social-media.fb', @shareFb

	shareFb: ->
		FB.ui
			method: 'share'
			display: 'popup'
			href: location.href
		, (response) ->




ready = ->
	SocialMedia.init()
# $(document).ready ready
$(document).on 'turbolinks:load', ready
SocialMedia =
	init: ->
		$('body').on 'click', '.social-media.fb', @shareFb
		$('body').on 'click', '.social-media.tw', @shareTw
		$('body').on 'click', '.social-media.pinterest', @sharePinterest


	shareFb: ->
		FB.ui
			method: 'share'
			display: 'popup'
			href: location.href
		, (response) ->

	shareTw: ->
		window.open("https://twitter.com/intent/tweet?", 'Tweet!', 'height=600px,width=800px');

	sharePinterest: ->
		currentUrl = location.href
		media = $("meta[property='og:image']").attr('content')
		description = $('.quiz-description').text()

		fullUrl = "https://www.pinterest.com/pin/create/button/?url=" + encodeURIComponent(currentUrl) + "&media=" +  encodeURIComponent(media) + "&description=" + encodeURIComponent(description)
		window.open(fullUrl, 'Pin it!', 'height=600px,width=800px');

ready = ->
	SocialMedia.init()
# $(document).ready ready
$(document).on 'turbolinks:load', ready
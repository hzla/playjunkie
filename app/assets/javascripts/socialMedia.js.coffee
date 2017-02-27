SocialMedia =
	init: ->
		$('body').on 'click', '.social-media.fb', @shareFb
		$('body').on 'click', '.social-media.tw', @shareTw
		$('body').on 'click', '.link', @showLink

	showLink: ->
		linkBox = $(@).parents('.social-medias').find('.link-box').show()
		linkBox.find('input').select()




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


# https://www.pinterest.com/pin/create/button/?url=http%3A%2F%2Fwww.playjunkie.com%2Fquizzes%2F193
# https://www.pinterest.com/pin/create/button/?url=http%3A%2F%2Fwww.playbuzz.com%2Fmatthewm14%2Fdo-you-see-beautiful-flowers-or-a-panda%3Futm_source%3Dpinterest.com%26utm_medium%3Dff%26utm_campaign%3Dff

ready = ->
	SocialMedia.init()
# $(document).ready ready
$(document).on 'turbolinks:load', ready
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
		text = encodeURIComponent($('.quiz-title').text() + " " + $('#link').val())
		window.open("https://twitter.com/intent/tweet?text=#{text}", 'Tweet!', 'height=600px,width=800px');

	sharePinterest: ->
		currentUrl = location.href
		media = $("meta[property='og:image']").attr('content')
		description = $('.quiz-description').text()

		fullUrl = "https://www.pinterest.com/pin/create/button/?url=" + encodeURIComponent(currentUrl) + "&media=" +  encodeURIComponent(media) + "&description=" + encodeURIComponent(description)
		window.open(fullUrl, 'Pin it!', 'height=600px,width=800px');

ready = ->
	SocialMedia.init()
$(document).on 'turbolinks:load', ready

Pinterest =
  load: ->
    delete window["PIN_"+~~((new Date).getTime()/864e5)]
    $.getScript("//assets.pinterest.com/js/pinit.js")

$(document).on 'turbolinks:load', ->
  Pinterest.load()

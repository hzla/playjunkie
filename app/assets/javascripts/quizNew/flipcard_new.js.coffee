FlipcardNew = #Flipcard specefic UI goes here
	init: ->
		$('body').on 'click', '.color', @chooseColor
		$('body').on 'click', '.add-card-text', @addCardText
		$('body').on 'click', '.side-chooser', @chooseSide
		$('body').on 'keyup', '.text-box', @syncItemText #syncs visible text with hidden fields
		@centerCardTexts()

	centerCardTexts: ->
		$('.text-box').each ->
			height = $(@).height()
			offset = (260 - height) / 2
			$(@).css('top', offset)



	chooseSide: ->
		card = $(@).parents('.question')
		card.find('.side-chooser').removeClass('selected')
		$(@).addClass('selected')
		
		if $(@).hasClass('choose-front')
			card.find('.flip-container').removeClass('flip')
		else
			card.find('.flip-container').addClass('flip')

	addCardText: ->
		card = $(@).parents('.question-image-input')
		card.find('.text-box')[0].contentEditable = true
		card.find('.text-box').focus()

	syncItemText: ->
		card = $(@).parents('.question-image-input')
		card.find('.card-text-input').val($(@).text())

		height = $(@).height()
		offset = (260 - height) / 2
		$(@).css('top', offset)

	chooseColor: ->
		card = $(@).parents('.question-image-input')
		color = $(@).css('background-color')
		card.css('background-color', color)
		card.find('input.question-image-input').val("")
		card.find('.close-image').hide()
		card.find('.image-preview').attr('src', '#').hide()
		card.find('.card-color-input').val(color)

ready = ->
	FlipcardNew.init()
$(document).ready ready
# $(document).on 'turbolinks:load', ready
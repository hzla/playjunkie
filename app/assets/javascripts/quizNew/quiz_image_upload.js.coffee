QuizImageUpload = #UI for creating/editing Quizzes goes here
	init: ->
		$('body').on 'change', "input[type='file']", @showImagePreview
		$('body').on 'click', '.close-image', @closeImage

	showImagePreview: -> 
		input = @
		uploadForm = $(input).parent()		
		formData = new FormData(uploadForm[0])
		
		$.ajax(
	    type: 'POST',
	    url: uploadForm.attr('action'),
	    processData: false,
	    enctype: 'multipart/form-data',
	    contentType: false,
	    data: formData
	  ).done ->
			imageKey = uploadForm.find("input[name='key']").val()
			imageKeyBack = null
			fileName = uploadForm.find("input[type='file']")[0].files[0].name
			imageKey = imageKey.replace("${filename}", fileName)
			modelId = uploadForm.attr 'model_id'
			modelName = uploadForm.attr 'model_name'
			
			#for flip cards
			if $(".back-side").length > 0 && $(".back-side input[type='file']").val() != ""
				imageKeyBack = imageKey
				imageKey = null

			$.post '/image_keys', 
				data: 
					image_key: imageKey 
					image_key_back: imageKeyBack
					model_id: modelId
					model_name: modelName


		if input.files && input.files[0]
			reader = new FileReader()
			reader.onload =  (e) ->
				previewBox = $(input).parent().next()
				previewBox.show()
				$(previewBox).css('background-image', "url(#{e.target.result})")
				previewBox.attr 'src', e.target.result
			
			reader.readAsDataURL input.files[0]
			$(@).parent().parent().find('.close-image').show()
			$(@).parents('.card-side').find('.card-color-input').val("")
			$(@).parents('.card-side').find('.question-image-input').attr('style', "").css('background', 'none')

	closeImage: ->
		box = $(@).parent()
		box.find('.image-preview').attr('src', '#').hide()
		box.find("input[type='file']").val("")
		$(@).hide()

ready = ->
	QuizImageUpload.init()
$(document).on 'ready', ready
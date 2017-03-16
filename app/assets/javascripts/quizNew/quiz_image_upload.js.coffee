QuizImageUpload = #UI for creating/editing Quizzes goes here
	init: ->
		$('body').on 'change', "input[type='file']", @showImagePreview
		$('body').on 'click', '.close-image', @closeImage
		$('body').on 'click', "input[type='file']", @updateLastselectedImage
		@lastSelectedImage = null

	updateLastselectedImage: ->
		QuizImageUpload.lastSelectedImage = $(@).val()

	showImagePreview: -> 
		input = @
		uploadForm = $(input).parent()		
		formData = new FormData(uploadForm[0])
		
		previewBox = $(input).parent().next()
		$(input).parent().parent().find('.input-overlay').text("")
		
		console.log $(@).val()
		console.log QuizImageUpload.lastSelectedImage
		if $(@).val() == QuizImageUpload.lastSelectedImage
			previewBox.find('.sk-wave').hide()
			return

		previewBox.css('display', 'flex')
		previewBox.find('.sk-wave').show()

		

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
			if ($(".back-side").length > 0 && $(input).parents('.question').length > 0 && $(input).parents('.question').find(".back-side input[type='file']").val() != "")
				imageKeyBack = imageKey
				imageKey = null

			$.post '/image_keys', 
				data: 
					image_key: imageKey 
					image_key_back: imageKeyBack
					model_id: modelId
					model_name: modelName
			, ->

				previewBox.find('.sk-wave').hide()
				if input.files && input.files[0]
					reader = new FileReader()
					reader.onload =  (e) ->
						previewBox = $(input).parent().next()
						previewBox.show()
						$(previewBox).css('background-image', "url(#{e.target.result})")
						previewBox.attr 'src', e.target.result
					
					reader.readAsDataURL input.files[0]
					$(input).parent().parent().find('.close-image').show()
					$(input).parents('.card-side').find('.card-color-input').val("")
					$(input).parents('.card-side').find('.question-image-input').attr('style', "").css('background', 'none')

	
	closeImage: ->
		box = $(@).parent()
		box.find('.input-overlay').text("Click to add image...")
		box.find('.image-preview').attr('src', 'blank').attr('style', '').hide()
		box.find("input[type='file']").val("")
		modelId = $(@).parent().find('.image-form').attr('model_id')
		modelName = $(@).parent().find('.image-form').attr('model_name')

		$.ajax 
			url: '/images',
			method: "DELETE"
			data: 
				model_id: modelId
				model_name: modelName
		$(@).hide()

ready = ->
	QuizImageUpload.init()
$(document).on 'ready', ready
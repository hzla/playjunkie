QuizNew =
	init: ->
		$('body').on 'change', '#quiz-image-input', @readURL
	

	readURL: -> 
		input = @
		console.log input
		if input.files && input.files[0]
			console.log input
			reader = new FileReader()
			reader.onload =  (e) ->
				console.log e
				$('#quiz-image-preview').show()
				$('#quiz-image-preview').attr 'src', e.target.result
			reader.readAsDataURL input.files[0]

ready = ->
	QuizNew.init()
$(document).ready ready
# $(document).on 'page:load', ready
class Search


	
	# Results are ordered by title, speaker_name, and description
	# results from each field are ordered by playlist, video, and challenges
	
	def self.search_for terms
		quizzes = Quiz.all
		quiz_items = QuizItem.all
		answers = ItemAnswer.all
		terms = terms.downcase
		results = [:text].map do |field|
			[quizzes, quiz_items, answers].map do |models|
				search_model_for(models, terms, field)
			end
		end.flatten.map(&:quiz).compact.uniq
	end

	private

	def self.search_model_for models, terms, field
		models.select {|n| n.send(field).downcase =~ /#{Regexp.escape(terms)}/}
	end



end
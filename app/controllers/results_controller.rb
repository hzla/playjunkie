class ResultsController < ApplicationController

	
	def create
		result = Result.create quiz_id: params[:quiz_id]
		render partial: "create", locals: {result: result, i: params[:i].to_i, quiz_type: params[:quiz_type]}
	end

	def destroy
		result = Result.find(params[:id])
		if result.quiz.user_id == current_user.id
			result.destroy
		end
		render nothing: true
	end

end
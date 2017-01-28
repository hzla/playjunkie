class SearchesController < ApplicationController

	def create
		@terms = params[:terms]
		@results = Search.search_for @terms
		render 'show'
	end

	def show
		@terms = params[:terms]
		@results = Search.search_for @terms
	end

end
class SearchesController < ApplicationController

	def create
		@page = 1
		@terms = params[:terms]
		@results = Search.search_for(@terms)[0..9]
		render 'show'
	end

	def show
		@page = params[:page] ? params[:page].to_i : 1
		@terms = params[:terms]
		offset = (((@page - 1) * 10))
		offset = 0 if offset == -1
		@results = Search.search_for(@terms)[offset..-1][0..9]
	end

end
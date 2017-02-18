class SearchesController < ApplicationController

	def create
		if @terms == ""
			@results = []
			render 'show' and return
		end
		@page = 1
		@terms = params[:terms]
		

		@full_results = Search.search_for(@terms)
		
		if @full_results.length == 0
			@results = []
			@last_page = true
			render 'show' and return
		end

		@results = @full_results[0..9]
		@results_count = @full_results.length
		@last_page = @results_count < 10
		
		render 'show'
	end

	def show
		@page = params[:page] ? params[:page].to_i : 1
		@terms = params[:terms]
		offset = (((@page - 1) * 10))
		offset = 0 if offset == -1

		if @terms == ""
			@results = []
			render 'show' and return
		end
		@full_results = Search.search_for(@terms)
		
		
		if @full_results[offset..-1]
			@results = @full_results[offset..-1][0..9]
			@results_count = @full_results.length
			@last_page = @results_count <= (10 * @page)
		else
			@results = []
			@last_page = true
		end
	end

end
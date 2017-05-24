class SearchesController < ApplicationController

  def index

  end

  def create
    @user = User.find(params[:user_id])
    @search = @user.search.new(params)
  end

	def index_by_tag
    @user = User.find(params[:user_id])
    entries = @user.entries.all
		@selected_entries = Array.new

		entries.each do |entry|
			if entry.tags.include? params[:tag]
				@selected_entries << entry
			end
		end
		unless @selected_entries.any?
			@error = "Tag does not exist"
			redirect_to user_path(@user, tag_error: @error)
		end
		@selected_tag = params[:tag]
		p Entry.where(title: "Formatting Date and Time")
	end

	def index_by_date
    @user = User.find(params[:user_id])
		entries = @user.entries.all
		@selected_entries = Array.new

		@selected_date = params[:selected_date]
		@error = String.new

		entries.each do |entry|
			if @selected_date == entry.created_at.strftime("%Y-%m-%d")
				@selected_entries << entry
			end
		end

		if @selected_date.to_date.future?
			@error = "Date cannot be in the future"
			redirect_to user_path(@user, date_error: @error)
		elsif @selected_entries.none?
			@error = "No entries for that date"
			redirect_to user_path(@user, error: @error)
		end
	end

	def index_by_keyword
    @user = User.find(params[:user_id])
		entries = @user.entries.all

		@selected_entries = Array.new
		@keyword = params[:keyword]

		entries.each do |entry|
			if /(?i)\b#{@keyword}\b/.match(entry.content) ||
				/(?i)\b#{@keyword}\b/.match(entry.tags) ||
				/(?i)\b#{@keyword}\b/.match(entry.title)
				@selected_entries << entry
			end
		end

		if @selected_entries.none?
			@error = "No entries available for that keyword"
			redirect_to user_path(@user, keyword_error: @error)
		end
	end
end

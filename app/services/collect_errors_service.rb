class CollectErrorsService

def initialize
end

def date(selected_date)
	if selected_date.to_date.future?
		@nonexistent_date_error = "Date cannot be in the future"
		render "entries/home"
	elsif selected_entries.none?
		@nonexistent_date_error = "No entries for that date"
		render "entries/home"
	end
end

def tag(selected_tag)

end

def keyword(selected_entries)
	if selected_entries.none?
		@nonexistent_keyword_error = "No entries available for that keyword"
		redirect_to "entries/home"
	end
end

end

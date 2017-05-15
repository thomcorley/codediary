class AddSearchTermToSearchModel < ActiveRecord::Migration[5.0]
  def change
    add_column :searches, :search_term, :string
  end
end

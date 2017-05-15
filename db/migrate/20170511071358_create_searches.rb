class CreateSearches < ActiveRecord::Migration[5.0]
  def change
    create_table :searches do |t|
      t.references :users, foreign_key: true

      t.timestamps
    end
  end
end

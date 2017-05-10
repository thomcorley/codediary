class CreateEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :entries do |t|
      t.text :title
      t.text :tags
      t.text :content
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

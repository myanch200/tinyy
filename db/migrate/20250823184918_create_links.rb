class CreateLinks < ActiveRecord::Migration[8.0]
  def change
    create_table :links do |t|
      t.text :original_url
      t.string :slug
      t.integer :clicks

      t.timestamps
    end
    add_index :links, :slug, unique: true
    add_index :links, "lower(original_url)", unique: true, name: "index_links_on_lower_original_url"
  end
end

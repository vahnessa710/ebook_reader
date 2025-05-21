class CreateBooks < ActiveRecord::Migration[8.0]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.string :description
      t.integer :gutendex_id
      t.string :download_url

      t.timestamps
    end
  end
end

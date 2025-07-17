class AddContentToBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :books, :content, :text
  end
end

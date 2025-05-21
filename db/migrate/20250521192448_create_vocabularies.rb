class CreateVocabularies < ActiveRecord::Migration[8.0]
  def change
    create_table :vocabularies do |t|
      t.references :user, null: false, foreign_key: true
      t.string :word
      t.text :definition

      t.timestamps
    end
  end
end

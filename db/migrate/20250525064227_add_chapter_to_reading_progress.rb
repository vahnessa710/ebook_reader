class AddChapterToReadingProgress < ActiveRecord::Migration[8.0]
  def change
    add_reference :reading_progresses, :chapter, null: false, foreign_key: true
  end
end

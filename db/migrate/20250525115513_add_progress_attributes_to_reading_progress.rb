class AddProgressAttributesToReadingProgress < ActiveRecord::Migration[8.0]
  def change
    add_column :reading_progresses, :progress_percentage, :float, default: 0.0
    add_column :reading_progresses, :last_read_at, :datetime
  end
end

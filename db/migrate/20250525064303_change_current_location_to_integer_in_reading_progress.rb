class ChangeCurrentLocationToIntegerInReadingProgress < ActiveRecord::Migration[8.0]
  def change
    change_column :reading_progresses, :current_location, :integer, using: 'current_location::integer'
    change_column_null :reading_progresses, :current_location, false
  end
end

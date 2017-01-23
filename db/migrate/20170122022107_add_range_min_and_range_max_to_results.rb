class AddRangeMinAndRangeMaxToResults < ActiveRecord::Migration[5.0]
  def change
    add_column :results, :range_min, :integer
    add_column :results, :range_max, :integer
  end
end

class AddOrderToQuizItems < ActiveRecord::Migration[5.0]
  def change
    add_column :quiz_items, :order, :integer
  end
end

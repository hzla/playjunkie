class AddCodeToQuizzes < ActiveRecord::Migration[5.0]
  def change
  	add_column :quiz_items, :remember_code, :string
  	add_column :item_answers, :remember_code, :string
  	add_column :results, :remember_code, :string
  end
end

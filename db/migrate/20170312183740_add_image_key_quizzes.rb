class AddImageKeyQuizzes < ActiveRecord::Migration[5.0]
  def change
  	add_column :quizzes, :image_key, :string
  	add_column :results, :image_key, :string
  	add_column :quiz_items, :image_key, :string
  	add_column :item_answers, :image_key, :string
  end
end

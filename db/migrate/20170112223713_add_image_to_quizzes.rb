class AddImageToQuizzes < ActiveRecord::Migration[5.0]
  def change
    add_column :quizzes, :image, :string
    add_column :quiz_items, :image, :string
    add_column :item_answers, :image, :string
    add_column :results, :image, :string
  end
end

class CreateQuizzes < ActiveRecord::Migration[5.0]
  def change
    create_table :quizzes do |t|
      t.string :title
      t.text :description
      t.text :completion_message

      t.timestamps
    end
  end
end

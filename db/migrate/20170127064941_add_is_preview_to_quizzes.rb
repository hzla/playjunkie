class AddIsPreviewToQuizzes < ActiveRecord::Migration[5.0]
  def change
    add_column :quizzes, :is_preview?, :boolean
  end
end

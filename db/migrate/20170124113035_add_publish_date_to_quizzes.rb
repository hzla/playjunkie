class AddPublishDateToQuizzes < ActiveRecord::Migration[5.0]
  def change
    add_column :quizzes, :publish_date, :datetime
  end
end

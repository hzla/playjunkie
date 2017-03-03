class AddViewCountsToQuizzes < ActiveRecord::Migration[5.0]
  def change
  	add_column :quizzes, :view_count_1, :integer, default: 0
  	add_column :quizzes, :view_count_2, :integer, default: 0
  	add_column :quizzes, :view_count_3, :integer, default: 0
  	add_column :quizzes, :view_count_4, :integer, default: 0
  	add_column :quizzes, :view_count_5, :integer, default: 0
  	add_column :quizzes, :view_count_6, :integer, default: 0
  	add_column :quizzes, :view_count_7, :integer, default: 0

  	add_column :quizzes, :trending_count, :integer, default: 0
  end
end

class AddFeaturedAndHomepagePickAndBrowsePickToQuizzes < ActiveRecord::Migration[5.0]
  def change
    add_column :quizzes, :featured, :boolean, default: false
    add_column :quizzes, :homepage_pick, :boolean, default: false
    add_column :quizzes, :browse_pick, :boolean, default: false
  end
end

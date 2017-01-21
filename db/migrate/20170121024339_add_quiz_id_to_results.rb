class AddQuizIdToResults < ActiveRecord::Migration[5.0]
  def change
    add_column :results, :quiz_id, :integer
    rename_column :item_answers, :question_id, :quiz_item_id

  end
end

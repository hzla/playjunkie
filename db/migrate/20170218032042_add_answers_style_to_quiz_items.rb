class AddAnswersStyleToQuizItems < ActiveRecord::Migration[5.0]
  def change
    add_column :quiz_items, :answer_style, :boolean
  end
end

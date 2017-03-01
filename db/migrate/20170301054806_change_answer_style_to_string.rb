class ChangeAnswerStyleToString < ActiveRecord::Migration[5.0]
  def change
    change_column :quiz_items, :answer_style, :string
  end
end

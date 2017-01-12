class CreateItemAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :item_answers do |t|
      t.text :answer_text
      t.string :image_credit
      t.integer :result_id
      t.integer :question_id
      t.boolean :correct?

      t.timestamps
    end
  end
end

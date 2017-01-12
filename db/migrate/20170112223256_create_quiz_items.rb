class CreateQuizItems < ActiveRecord::Migration[5.0]
  def change
    create_table :quiz_items do |t|
      t.string :title
      t.string :image_credit
      t.string :image_credit_back
      t.string :color
      t.string :color_back
      t.text :item_text
      t.integer :quiz_id

      t.timestamps
    end
  end
end

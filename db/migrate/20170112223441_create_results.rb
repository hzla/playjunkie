class CreateResults < ActiveRecord::Migration[5.0]
  def change
    create_table :results do |t|
      t.text :result_text
      t.string :image_credit
      t.string :range

      t.timestamps
    end
  end
end

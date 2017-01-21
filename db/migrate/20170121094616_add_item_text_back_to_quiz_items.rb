class AddItemTextBackToQuizItems < ActiveRecord::Migration[5.0]
  def change
    add_column :quiz_items, :item_text_back, :text
  end
end

class AddImageBackToQuizItems < ActiveRecord::Migration[5.0]
  def change
    add_column :quiz_items, :image_back, :string
  end
end

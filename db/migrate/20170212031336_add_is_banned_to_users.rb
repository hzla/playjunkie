class AddIsBannedToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :is_banned?, :boolean
  end
end

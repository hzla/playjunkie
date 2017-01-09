class CreateAuthorizations < ActiveRecord::Migration[5.0]
  def change
    create_table :authorizations do |t|
      t.datetime :created_at

      t.integer :user_id
      t.string :unique_id
    end

    add_index :authorizations, :user_id
    add_index :authorizations, :unique_id

  end
end

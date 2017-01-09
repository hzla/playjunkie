class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
    	t.datetime :created_at
    	t.datetime :updated_at

    	t.string :name
    	t.string :email
    	t.text :description
    	t.string :profile_pic_url
    end
  end
end

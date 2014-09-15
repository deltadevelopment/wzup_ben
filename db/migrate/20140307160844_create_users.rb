class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.integer :phone_number
      t.string :display_name
      t.integer :availability 
      t.string :password
      t.string :api_key

      t.timestamps
    end
  end
end

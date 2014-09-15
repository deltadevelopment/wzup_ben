class AddHashToUser < ActiveRecord::Migration
  def change
    add_column :users, :password_hash, :string
    add_column :users, :password_salt, :string
    remove_column :users, :password, :string
  end
end

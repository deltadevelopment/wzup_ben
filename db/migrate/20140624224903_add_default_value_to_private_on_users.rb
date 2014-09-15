class AddDefaultValueToPrivateOnUsers < ActiveRecord::Migration
  def change
    change_column :users, :private, :boolean, default: true
  end
end

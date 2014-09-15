class ChangePrivateName < ActiveRecord::Migration
  def change
    rename_column :users, :private, :private_profile    
  end
end

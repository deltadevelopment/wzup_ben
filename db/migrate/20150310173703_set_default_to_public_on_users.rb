class SetDefaultToPublicOnUsers < ActiveRecord::Migration
  def change
    change_column :users, :private_profile, :boolean, :defaut => false
  end
end

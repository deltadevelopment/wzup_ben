class SetDefaultToPublicOnUsers < ActiveRecord::Migration
  # This migration has a typo `defaut => false` but needs to be kept because of a migration error
  def change
    change_column :users, :private_profile, :boolean, :defaut => false
  end
end

class ChangeApiFieldsOnUsers < ActiveRecord::Migration
  def change
    rename_column :users, :api_key, :authentication_token
  end
end

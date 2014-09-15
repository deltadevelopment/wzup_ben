class RenameColumnOnFollowings < ActiveRecord::Migration
  def change
    rename_column :followings, :follower_id, :followee_id
  end
end

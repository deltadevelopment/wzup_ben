class CreateFollowingRequests < ActiveRecord::Migration
  def change
    create_table :following_requests do |t|
      t.references :user
      t.references :followee
      t.timestamps
    end
  end
end

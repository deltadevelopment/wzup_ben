class AddMediaToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :media_key, :string
    add_column :statuses, :media_type, :integer, :default => 0
  end
end

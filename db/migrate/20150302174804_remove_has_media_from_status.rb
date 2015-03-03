class RemoveHasMediaFromStatus < ActiveRecord::Migration
  def change
    remove_column :statuses, :has_media
  end
end

class RemoveHasMediaFromStatus < ActiveRecord::Migration
  def change
    remove_column :status, :has_media
  end
end

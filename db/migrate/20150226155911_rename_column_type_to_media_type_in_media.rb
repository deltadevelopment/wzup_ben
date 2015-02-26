class RenameColumnTypeToMediaTypeInMedia < ActiveRecord::Migration
  def change
    rename_column :media, :type, :media_type
  end
end

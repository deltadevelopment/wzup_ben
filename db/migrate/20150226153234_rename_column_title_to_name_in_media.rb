class RenameColumnTitleToNameInMedia < ActiveRecord::Migration
  def change
    rename_column :media, :title, :name
  end
end

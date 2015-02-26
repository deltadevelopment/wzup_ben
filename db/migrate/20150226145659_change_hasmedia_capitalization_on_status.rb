class ChangeHasmediaCapitalizationOnStatus < ActiveRecord::Migration
  def change
    rename_column :statuses, :hasmedia, :has_media
  end
end

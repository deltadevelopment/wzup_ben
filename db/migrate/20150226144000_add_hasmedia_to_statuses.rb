class AddHasmediaToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :hasmedia, :boolean, :default => :false
  end
end

class AddDefaultPrivateToEvents < ActiveRecord::Migration
  def change
    change_column :events, :private, :boolean, :default => true
  end
end

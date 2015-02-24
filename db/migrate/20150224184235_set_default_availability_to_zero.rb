class SetDefaultAvailabilityToZero < ActiveRecord::Migration
  def change
    change_column :users, :availability, :int, :default => 0
  end
end

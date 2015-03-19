class AddDeviceTypeToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :device_type, :integer
  end
end

class RemoveDeviceInfoFromSessions < ActiveRecord::Migration
  def change
    remove_column :sessions, :device_type
    remove_column :sessions, :device_id
  end
end

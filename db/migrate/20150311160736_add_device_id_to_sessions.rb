class AddDeviceIdToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :device_id, :string
  end
end

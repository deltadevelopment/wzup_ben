class AddDeviceIdToSessionsAgain < ActiveRecord::Migration
  def change
    add_column :sessions, :device_id, :string
  end
end

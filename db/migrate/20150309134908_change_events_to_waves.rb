class ChangeEventsToWaves < ActiveRecord::Migration
  def change
    rename_table :events, :waves
  end
end

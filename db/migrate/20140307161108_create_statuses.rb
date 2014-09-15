class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :body
      t.string :location 
      t.references :user

      t.timestamps
    end
  end
end

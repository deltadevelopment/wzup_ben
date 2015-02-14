class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.string :description
      t.string :place
      t.string :location
      t.datetime :time
      t.boolean :private
      t.integer :degrees
      t.references :user
      
      t.timestamps
    end
  end
end

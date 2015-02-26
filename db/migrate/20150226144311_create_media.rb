class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.string :title
      t.integer :type
      t.references :status
      t.timestamps
    end
  end
end

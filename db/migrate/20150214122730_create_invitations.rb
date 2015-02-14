class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.references :user
      t.references :event
      t.references :invitee
      t.integer :attending

      t.timestamps
    end
  end
end

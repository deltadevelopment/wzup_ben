class ChangeInvitationsDefaultAttending < ActiveRecord::Migration
  def change
    change_column :invitations, :attending, :integer, :default => 0
  end
end

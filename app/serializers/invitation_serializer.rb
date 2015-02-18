class InvitationSerializer < ActiveModel::Serializer
  attributes :id, :attending
  
  has_one :invitee

end

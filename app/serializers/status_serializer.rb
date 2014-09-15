class StatusSerializer < ActiveModel::Serializer
  attributes :id, :body, :location, :user_id

  has_one :user

  def filter(keys)
    if not_private_or_followee
      keys 
    else
      keys - [:id]    
    end
  end
  
  def not_private_or_followee
    # Check if the user has a private profile, if not check first if the requestor is authenticated
    # and then if he's a followee of the user.
    !User.find(object.user_id).has_private_profile? or scope and scope.is_followee?(object.id)
  end

end

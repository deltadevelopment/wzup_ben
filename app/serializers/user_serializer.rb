class UserSerializer < ActiveModel::Serializer 
 attributes :id, :username, :private_profile, :display_name, :availability, :is_followee
  
  # TODO: Should the status be included with the JSON for the user?
  # has_one :status

  def filter(keys)
    if owner_or_follower or !object.has_private_profile?
      keys
    else
      keys - [:availability, :display_name]
    end
  end

  def owner_or_follower
    scope.is_follower?(object.id) or scope.is_owner?(object)
  end

end

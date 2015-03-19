class UserSerializer < ActiveModel::Serializer 
 attributes :id, :username, :private_profile, :display_name, :availability, :is_followee, :email, :phone_number
  
  # TODO: Should the status be included with the JSON for the user?
  # has_one :status

  def filter(keys)
    if scope.is_owner?(object)
      keys
    elsif scope.is_follower?(object.id) or !object.has_private_profile?
      keys - [:phone_number, :email]
    else
      keys - [:availability, :display_name]
    end
  end

end

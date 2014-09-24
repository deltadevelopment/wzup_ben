class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :private_profile, :display_name, :availability, :phone_number
  
  # TODO: Should the status be included with the JSON for the user?
  # has_one :status

  def filter(keys)
    if owner_or_followee 
      keys 
    elsif !object.has_private_profile? 
      keys - [:phone_number, :availability]  
    else
      keys - [:phone_number, :availability, :display_name]
    end
  end

  def owner_or_followee
    scope.is_followee?(object.id) or scope.is_owner?(object)
  end

end

class UserSerializer < ApplicationSerializer 
  attributes :id, :username, :private_profile, :display_name, :availability, :phone_number
  
  # TODO: Should the status be included with the JSON for the user?
  # has_one :status

  def filter(keys)
    if owner_or_follower
      keys 
    elsif !object.has_private_profile? 
      keys - [:phone_number, :availability]  
    else
      keys - [:phone_number, :availability, :display_name]
    end
  end

  def owner_or_follower
    scope.is_follower?(object.id) or scope.is_owner?(object)
  end

end

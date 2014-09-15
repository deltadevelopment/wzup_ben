class UserSerializer < ActiveModel::Serializer
  attributes :id, :username
  
  # TODO: Should the status be included with the JSON for the user?
  # There is an issue with not displaying it if the user is private, as well. 
  # has_one :status

  def attributes
    data = super
    
    if not_private_or_followee
      data[:display_name] = object.display_name
      data[:availability] = object.availability
    end

    data
    
  end

  def filter(keys)
    if not_private_or_followee
      keys 
    else
      keys - [:display_name]    
    end
  end
  
  def not_private_or_followee
    # Check if the user has a private profile, if not check first if the requestor is authenticated
    # and then if he's a followee of the user.
    !object.has_private_profile? or scope and scope.is_followee?(object.id)
  end

end

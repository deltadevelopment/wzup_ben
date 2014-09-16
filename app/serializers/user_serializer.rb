class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :private_profile
  
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
  
  def not_private_or_followee
    !object.has_private_profile? or scope.is_followee?(object.id)
  end

end

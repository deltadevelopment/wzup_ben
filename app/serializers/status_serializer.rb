class StatusSerializer < ActiveModel::Serializer
  attributes :id, :body, :location, :user_id

  has_one :user

  def filter(keys)
    if not_private_or_followee
      keys 
    else
      keys - [:body, :location, :availability]
    end
  end
  
  def not_private_or_followee
    !object.user.has_private_profile? or scope.is_followee?(object.id)
  end

end

class StatusSerializer < ActiveModel::Serializer
  attributes :id, :body, :location, :user_id

  has_one :user

  def filter(keys)
    if owner_or_follower 
      keys 
    else
      keys - [:body, :location, :availability]
    end
  end

  def owner_or_follower
    scope.is_follower?(object.id) or scope.is_owner?(object.user)
  end

end

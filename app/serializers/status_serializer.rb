class StatusSerializer < ActiveModel::Serializer
  attributes :id, :body, :location, :user_id, :has_media, :media

  has_one :user

  def filter(keys)
    if owner_or_follower 
      keys 
    else
      keys - [:body, :location, :availability]
    end
  end

  def media
    object.media if object.has_media
  end

  def owner_or_follower
    scope.is_follower?(object.id) or scope.is_owner?(object.user)
  end

end

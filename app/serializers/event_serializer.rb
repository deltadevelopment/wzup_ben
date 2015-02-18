class EventSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :place, :location,
             :time, :private, :degrees

  def filter(keys)
    if owner_or_invited
      keys
    else
      keys - [:title, :description, :place, :location, :time, :degrees] 
    end
  end

  def owner_or_invited
    scope.is_owner?(object.user)
  end
    
end

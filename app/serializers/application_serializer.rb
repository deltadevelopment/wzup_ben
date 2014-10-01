class ApplicationSerializer < ActiveModel::Serializer
  def owner_or_follower
    scope.is_follower?(object.id) or scope.is_owner?(object)
  end
end

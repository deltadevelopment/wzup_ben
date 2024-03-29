class FollowerSerializer < ActiveModel::Serializer
  # TODO: Is the user being cached between requests, or are we performing a new lookup for object.user for every request?
  # TODO: Include some link to profile image?
  def attributes
    data = super

    if owner_or_follower or !object.followee.has_private_profile?
      data[:id] = object.id
      data[:user] = {'id' => object.user.id, 
                     'username' => object.user.username,
                     'display_name' => object.user.display_name,
                     'is_followee' => object.user.is_followee
                    }
    end

    data
  end
  
  # TODO: This currently allow followees to see everything that a follower does.
  def owner_or_follower
    scope.is_follower?(object.followee.id) or scope.is_owner?(object.followee)
  end
end

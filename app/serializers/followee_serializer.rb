class FolloweeSerializer < ActiveModel::Serializer
  # TODO: Is the user being cached between requests, or are we performing a new lookup for object.user for every request?
  # TODO: Include some link to profile image?

  def attributes
    data = super

    if owner_or_follower or !object.user.has_private_profile?
      data[:id] = object.id
      data[:user] = {'id' => object.followee.id, 
                     'username' => object.followee.username,
                     'display_name' => object.followee.display_name,
                     'is_followee' => object.followee.is_followee
                    }
    end

    data
  end
  
  # TODO: This currently allow followees to see everything that a follower does.
  def owner_or_follower
    scope.is_follower?(object.user.id) or scope.is_owner?(object.user)
  end
end

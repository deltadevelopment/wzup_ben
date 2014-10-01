class FollowingSerializer < ApplicationSerializer 

  # TODO: Is the user being cached between requests, or are we performing a new lookup for object.user for every request?
  # TODO: Include some link to profile image?

  def attributes
    data = super

    if owner_or_follower or !object.user.has_private_profile?
      data[:id] = object.id
      data[:user] = {'id' => object.user.id, 
                     'username' => object.user.username
                    }
      data[:followee] = {'id' => object.followee.id, 
                     'username' => object.followee.username
                    }
    end

    data
  end

end

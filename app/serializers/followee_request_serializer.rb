class FolloweeRequestSerializer < ActiveModel::Serializer
  attributes :id


  def attributes
    data = super

    if scope.is_owner?(object.user)
      data[:id] = object.id
      data[:user] = {'id' => object.followee.id, 
                     'username' => object.followee.username,
                     'display_name' => object.followee.display_name,
                     'private_profile' => object.followee.private_profile
                    }
    end

    data
  end

end

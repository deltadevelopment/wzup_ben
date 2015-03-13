class FollowingRequestSerializer < ActiveModel::Serializer
  attributes :id


  def attributes
    data = super

    if scope.is_owner?(object.followee)
      data[:id] = object.id
      data[:user] = {'id' => object.user.id, 
                     'username' => object.user.username,
                     'display_name' => object.user.display_name
                    }
    end

    data
  end

end

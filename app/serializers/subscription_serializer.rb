class SubscriptionSerializer < ActiveModel::Serializer

  def attributes
    data = super

    if scope.is_owner?(object.user)  
      data[:id] = object.id
      data[:user] = {'id' => object.subscribee.id, 
                     'username' => object.subscribee.username,
                     'display_name' => object.subscribee.display_name
                    }
    end

    data
  end
end

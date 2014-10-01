class StatusSerializer < ApplicationSerializer
  attributes :id, :body, :location, :user_id

  has_one :user

  def filter(keys)
    if owner_or_follower 
      keys 
    else
      keys - [:body, :location, :availability]
    end
  end

end

class FollowingsController < ApplicationController

  def create
    user = User.find_by_id(params[:id])

    if !user
      record_not_found 
    else      
      following = Following.find_or_create_by(user_id: params[:id], followee_id: params[:followee_id])

      if following
        resource_created        
      else
        resource_could_not_be_created
      end
    end
  end

  def destroy
    user = User.find_by_id(params[:id])

    if !user
      record_not_found 
    else      
      following = Following.find_by_user_id_and_followee_id(params[:id], params[:followee_id])
      if following
        if following.destroy
          resource_destroyed      
        else
          internal_server_error
        end
      else
        record_not_found
      end
    end
  end

  def get_followers
    # Refactor out instance variables?

    following = Following.where(followee_id: params[:id])

    if following.empty? or !following
      record_not_found
    else
      render json: following, status: 200
    end
  end

  def get_followees
    # Refactor out instance variables?

    following = Following.where(user_id: params[:id]).load

    if following.empty? or !following
      record_not_found
    else
      render json: following, status: 200
    end
  end

end

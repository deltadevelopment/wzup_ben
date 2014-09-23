class FollowingsController < ApplicationController

  before_filter :check_session

  def create
    user = User.find_by_id(params[:id])
    followee = User.find_by_id(params[:followee_id])

    return not_authorized unless current_user == user
    
    if Following.find_or_create_by(user_id: params[:id], followee_id: followee.id) 
      resource_created        
    else
      resource_could_not_be_created
    end
  end

  def destroy
    user = User.find_by_id(params[:id])

    return not_authorized unless confirm_owner(params[:id])
    
    if Following.find_by_user_id_and_followee_id(params[:id], params[:followee_id]).destroy
      resource_destroyed      
    else
      internal_server_error
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

class FollowingsController < ApplicationController
  before_filter :check_session

  def create_or_request
    user = User.find_by_id!(params[:id])
    followee = User.find_by_id!(params[:followee_id])

    return not_authorized unless current_user == user

    if followee.has_private_profile? 
      FollowingRequest.find_or_create_by(user_id: user.id, followee_id: followee.id)
      request_created
    else
      create(user.id, followee.id)
    end
  end

  def accept_following
    user = User.find_by_id!(params[:id])
    follower = User.find_by_id!(params[:follower_id])
    following_request = FollowingRequest.where(user_id: follower.id, followee_id: user.id)
    return not_authorized unless current_user == user
    
    if following_request.exists?
      create(follower.id, user.id, following_request)
    else
      record_not_found
    end
  end

  def destroy
    following = Following.find_by_user_id_and_followee_id!(params[:id], params[:followee_id])

    return not_authorized unless confirm_owner(following)
    
    if following.destroy
      resource_destroyed      
    else
      internal_server_error
    end

  end

  def get_followers
    followers = Following.where(followee_id: params[:id])
    followees = Following.where(user_id: current_user.id).pluck(:followee_id)

    return record_not_found if followers.empty?

    followee = followers[0].followee

    return not_authorized unless current_user.is_follower_or_owner?(followee) or !followee.has_private_profile?

    followers.each do |f|
      f.user.is_followee = followees.include?(f.user.id)
    end

    render json: followers, status: 200, each_serializer: FollowerSerializer, meta: { total: followers.size }
  end

  def get_followees
    following = Following.where(user_id: params[:id])

    return record_not_found if following.empty?

    user = following[0].user

    return not_authorized unless current_user.is_follower_or_owner?(user) or !user.has_private_profile?

    render json: following, status: 200, each_serializer: FolloweeSerializer, meta: { total: following.size }
  end

  def get_following_requests
    requests = FollowingRequest.where(followee_id: params[:id])

    return record_not_found if requests.empty?

    user = requests[0].followee

    return not_authorized unless current_user == user

    render json: requests, status: 200, each_serializer: FolloweeSerializer, meta: { total: requests.size }
  end

  private

  def create(user_id, followee_id, following_request=nil)
    if Following.find_or_create_by(user_id: user_id, followee_id: followee_id) 

      if following_request == FollowingRequest.new
        following_request.destroy
      end 

      resource_created        
    else
      resource_could_not_be_created
    end
  end

end

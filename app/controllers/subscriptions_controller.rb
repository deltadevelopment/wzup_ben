class SubscriptionsController < ApplicationController
  before_filter :check_session

  def create
    user = User.find_by_id!(params[:id])
    subscribee = User.find_by_id!(params[:subscribee_id])

    return not_authorized unless current_user == user

    if subscribee.has_private_profile? and !subscribee.is_followee?(user)
      render json: {"error": "You can not subscribe to private users you don't follow"}.to_json, status: 400
    end

    if Subscription.find_or_create_by(user_id: user.id, subscribee_id: subscribee.id) 
      resource_created        
    else
      resource_could_not_be_created
    end
  end

  def destroy
    subscription = Subscription.find_by_user_id_and_subscribee_id!(params[:id], params[:subscribee_id])

    return not_authorized unless confirm_owner(subscription)
    
    if subscription.destroy
      resource_destroyed      
    else
      internal_server_error
    end

  end

  def get_subscribees
    return not_authorized unless current_user.id == params[:id]

    subscription = Subscription.where(user_id: params[:id])

    return record_not_found if subscription.empty?

    render json: subscription, status: 200, each_serializer: SubscriptionSerializer, meta: { total: subscription.size }
  end

end

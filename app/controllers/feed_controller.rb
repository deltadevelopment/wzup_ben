class FeedController < ApplicationController

  before_action :check_session  

  def list
    followees = Following.where(user_id: current_user)

    followee_ids = []
    followees.each { |f| followee_ids.push(f.followee_id) }

    statuses = Status.where("user_id IN (?)", followee_ids)

    statuses.each { |s| s.generate_download_uri }

    render json: statuses

  end   

  def generate_feed

  end

end

class FeedController < ApplicationController

  before_action :check_session  

  def list
    followees = Following.where(user_id: current_user)

    followee_ids = []
    followees.each { |f| followee_ids.push(f.followee_id) }

    statuses = Status.where("user_id IN (?)", followee_ids)

    statuses.each do |s|
      
      if s.media_type != 0
        obj = Aws::S3::Object.new(bucket_name: ENV['S3_BUCKET'], key: s.media_key)
        s.media_url = obj.presigned_url(:get, expires_in: 3600)
      end
    end

    render json: statuses

  end   

  def generate_feed

  end

end

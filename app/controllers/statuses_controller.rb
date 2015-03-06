class StatusesController < ApplicationController
  # Update to include every action that requires a key present
  before_action :check_session


  def show
    # TODO: Check if the user is authenticated to view the status
    status = Status.find_by(:user_id => params[:user_id])

    status.generate_download_uri

    if !status
      record_not_found
    else
      render json: status
    end
  end

  def create(user_id)
    # Initialize first status
    # TODO: Change initial values. Should be empty?
    status = Status.new(user_id: user_id, body: "My first status", location: "Home")
    
    if status.save
     true
    else
     false
    end 

  end 

  def update
    status = Status.find_by(:user_id => params[:user_id])
    
    return not_authorized unless current_user == status.user 

    if !status
      record_not_found
    else
      if status.update_attributes(update_params)
        render json: status, status: 200
      else
        check_errors_or_500(status)
      end
    end

  end

  def add_media
    status = Status.find_by(:user_id => params[:user_id]) 

    return not_authorized unless current_user == status.user 

    if !status
      record_not_found
    else
      if status.update_attributes(add_media_params)
        render json: {'success' => 'Resource created'}.to_json, status: 200
      else
        check_errors_or_500(status)
      end
    end

  end

  def generate_upload_uri

    s3 = Aws::S3::Resource.new
    key = SecureRandom::hex(40)
    
    obj = s3.bucket(ENV['S3_BUCKET']).object(key)
    url = URI::parse(obj.presigned_url(:put))

    res = { :url => url.to_s, :key => key }.to_json

    render json: res, status: 200

  end

  def generate_download_uri
    obj = Aws::S3::Object.new(bucket_name: ENV['S3_BUCKET'], key: self.media_key)
    self.media_url = obj.presigned_url(:get, expires_in: 3600)
  end

  private

  def update_params
    params.require(:status).permit(:body, :location)
  end

  def add_media_params
    params.require(:status).permit(:media_key, :media_type)
  end

end

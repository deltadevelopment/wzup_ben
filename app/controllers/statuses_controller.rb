class StatusesController < ApplicationController
  # Update to include every action that requires a key present
  before_action :check_session


  def show
    # TODO: Check if the user is authenticated to view the status
    status = Status.find_by(:user_id => params[:user_id])

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

  def generate_upload_url

    s3 = Aws::S3::Resource.new
    key = SecureRandom::hex(40)
    
    obj = s3.bucket(ENV['S3_BUCKET']).object(key)
    url = URI::parse(obj.presigned_url(:put))

    res = { :url => url.to_s }.to_json

    render json: res, status: 200

  end

  private

  def update_params
    params.require(:status).permit(:body, :location)
  end

end

class MediaController < ApplicationController
  before_action :check_session

  def create
    params[:media].merge!({status_id: params[:status_id]})
    media = Media.new(create_params)
    status = Status.find(params[:status_id])

    return not_authorized unless current_user == Status.find(params[:status_id]).user 

    return bad_request unless Media.where(status_id: status.id).empty?
    
    if media.save 
      resource_created
    else
      check_errors_or_500(media)
    end 

  end 

  private

  def create_params 
    params.require(:media).permit(:name, :media_type, :status_id)
  end

end

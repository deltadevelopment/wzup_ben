class StatusesController < ApplicationController

  def show
    # TODO: Check if the user is authenticated to view the status
    @status = Status.find_by(:user_id => params[:user_id])

    if !@status
      record_not_found
    else
      render json: @status
    end
  end

  def create(user_id)
    # Initialize first status
    # TODO: Change initial values. Should be empty?
    @status = Status.new(user_id: user_id, body: "My first status", location: "Home")
    
    if @status.save
     true
    else
     false
    end 

  end 

  def update
    @status = Status.find_by(:user_id => params[:user_id])
    
    if !@status
      record_not_found
    else
      if @status.update_attributes(update_params)
        render json: @status, status: 200
      else
        check_errors_or_500(@status)
      end
    end

  end

  # TODO: Should probably do some checking as to whether
  #       it actually happens, and get returned
  def destroy(user_id)
    @status = Status.find_by(:user_id => user_id)

    @status.destroy
  end

  private

  def update_params
    params.require(:status).permit(:body, :location)
  end

end

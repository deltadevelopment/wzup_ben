class EventsController < ApplicationController

  before_action :check_session

  def show
    event = Event.find(params[:id])

    render json: event
  end

  def create
    event = Event.new(create_params)
    event.user = current_user

    if event.save
        render json: {success: "Resource created", event: event }.to_json, status: 201
    else
      check_errors_or_500(event)
    end
  end

  def update
    event = Event.find(params[:id])

    return not_authorized unless current_user == event.user

    if event.update_attributes(update_params)
      render json: event, status: 200
    else
      check_errors_or_500(event)
    end

  end


  def destroy
    event = Event.find(params[:id])

    return not_authorized unless current_user == event.user

    if event.destroy
      render json: {success: "Event deleted"}.to_json, status: 200
    else
      # TODO: Should be logged
      render json: {error: "Could not delete event"}.to_json, status: 500
    end
  end

  private


  def create_params 
    params.require(:event).permit(:title, :description, :place, :location, :time, :private)
  end

  def update_params
    params.require(:event).permit(:title, :description, :place, :location, :time, :private)
  end

end

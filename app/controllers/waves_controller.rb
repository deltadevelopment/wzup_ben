class WavesController < ApplicationController

  before_action :check_session

  def show
    wave = Wave.find(params[:id])

    render json: wave
  end

  def create
    wave = Wave.new(create_params)
    wave.user = current_user

    if wave.save
        render json: {success: "Resource created", wave: wave }.to_json, status: 201
    else
      check_errors_or_500(wave)
    end
  end

  def update
    wave = Wave.find(params[:id])

    return not_authorized unless current_user == wave.user

    if wave.update_attributes(update_params)
      render json: wave, status: 200
    else
      check_errors_or_500(wave)
    end

  end


  def destroy
    wave = Wave.find(params[:id])

    return not_authorized unless current_user == wave.user

    if wave.destroy
      render json: {success: "wave deleted"}.to_json, status: 200
    else
      # TODO: Should be logged
      render json: {error: "Could not delete wave"}.to_json, status: 500
    end
  end

  private


  def create_params 
    params.require(:wave).permit(:title, :description, :place, :location, :time, :private)
  end

  def update_params
    params.require(:wave).permit(:title, :description, :place, :location, :time, :private)
  end

end

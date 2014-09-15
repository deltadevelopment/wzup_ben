class ApplicationController < ActionController::API

  # Authorization

  def check_session
    @session = Session.find_by_auth_token(params[:api_key])

    unless @session
      not_authorized 
    end
  end
  
  def check_api_key_presence
    unless params[:api_key]
      invalid_token
      false
    else
      true
    end
  end

  # Error Messages
  
  def user_is_private
    render json: {error: "User has a private profile", code: "private_profile"}, status: 403 
  end
  
  def invalid_token 
    render json: {error: "Invalid token", code: "invalid_token"}, status: 403 
  end

  # Checks if there are any validation errors, and renders them, or sets http status 500
  def check_errors_or_500(object)
     
    if(object.errors.messages)
      render json: object.errors.messages.to_json, status: 400
    else
      render json: {error: "Internal server error"}.to_json, status: 500
    end

  end
  def internal_server_error
      render json: {error: "Internal server error"}.to_json, status: 500
  end 

  # Renders not found json, and sets status to 404
  def record_not_found
    render json: {error: "Record not found"}.to_json, status: 404
  end

  def resource_created
    render json: {success: "Resource created"}.to_json, status: 201
  end

  def resource_destroyed
    render json: {success: "Resource destroyed"}.to_json, status: 200
  end

  def resource_could_not_be_created
    # TODO: This should be logged
    render json: {error: "Resource could not be created"}, status: 500
  end

  def not_authorized 
    render json: {error: "Not authorized"}.to_json, status: 403
  end
end

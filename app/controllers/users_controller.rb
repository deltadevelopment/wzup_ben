class UsersController < ApplicationController
  serialization_scope :current_user 
  # Update to include every action that requires a key present
  before_action :check_session, except: :create
 
  def show
    @user = User.find(params[:id])
    
    # Unsure if this clause works
    if !@user
      record_not_found
    else   
      render json: @user
    end
  end

  def create
    @user = User.new(register_params)
    @status = StatusesController.new

    if @user.save
      if @status.create(@user.id)
        render json: {success: "Resource created", user: remove_unsafe_keys(@user) }.to_json, status: 201
      else
        resource_could_not_be_created 
      end
    else
      check_errors_or_500(@user)
    end
  end

  def update

    # Check if token owner is the actual user 
    if @session.user_id == params[:id].to_i
      @user = User.find_by_id(params[:id])
   
      if !@user
        record_not_found
      else
        if @user.update_attributes(update_params)
          render json: @user, status: 200
        else
          check_errors_or_500(@user)
        end
      end
    else
      not_authorized
    end

  end


  def destroy
    @user = User.find_by_id(params[:id])

    @status = StatusesController.new

    if @user
      user_id = @user.id
      if @user.destroy
        @status.destroy(user_id)
        render json: {success: "User deleted"}.to_json
      else
        # TODO: Should be logged
        render json: {error: "Could not delete user"}.to_json, status: 500
      end
    else
      record_not_found 
    end
  end
  
  # Used in serializer
  def current_user
    unless auth_token = get_auth_token
      return false
    else
      user = find_user_by_token(auth_token)
    end
  end   

  def find_user_by_token(api_key)
    token = Session.find_by_auth_token(api_key)
    
    if token 
      user = User.find_by_id(token.user_id)
      if user
        user
      else
        # Is this the correct error message for this incident?
        record_not_found
      end
    else
      invalid_token 
    end
    
  end
  
  # Used in SessionsController#create
  def self.authenticate(username, password)
   
    user = User.find_by_username(username)

    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      # Return false
      nil
    end

  end

  private  
  

  def remove_unsafe_keys(user)
    user.slice('id', 'display_name', 'username', 'email', 'phone_number')
  end

  def register_params 
    params.require(:user).permit(:username, :email, :phone_number, :display_name, :password)
  end

  def update_params 
    params.require(:user).permit(:username, :email, :phone_number, :display_name, :password, :private_profile)
  end

end

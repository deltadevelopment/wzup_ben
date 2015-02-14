class InvitationsController < ApplicationController

  before_action :check_session

  def list 
    event = Event.find(params[:event_id])

    return not_authorized unless current_user.is_invitee_or_owner?

    invitations = Invitation.find_by_event_id(params[:event_id])

    render json: invitations
  end

  def show
    invitation = Invitation.find(params[:id])

    render json: invitation
  end

  def create
    event = Event.find(params[:event_id])
    user = User.find(params[:invitee_id])
    invitation = Invitation.find_or_create_by(create_params)
    invitation.user = current_user

    return not_authorized unless current_user.is_owner?(event.user)

    return json_error("You can not invite yourself", 400) if invitation.invitee == current_user

    if invitation.save
        render json: {success: "Resource created", invitation: invitation}.to_json, status: 201
    else
      check_errors_or_500(invitation)
    end
  end

  def update
    invitation = Invitation.find_by_event_id_and_invitee_id(params[:event_id], params[:invitee_id])

    return not_authorized unless current_user == invitation.invitee

    if invitation.update_attributes(update_params)
      render json: invitation, status: 200
    else
      check_errors_or_500(invitation)
    end

  end


  def destroy
    invitation = Invitation.find(params[:id])

    return not_authorized unless current_user == invitation.user

    if invitation.destroy
      render json: {success: "Invitation deleted"}.to_json, status: 200
    else
      # TODO: Should be logged
      render json: {error: "Could not delete invitation"}.to_json, status: 500
    end
  end

  private


  def create_params 
    params.permit(:event_id, :invitee_id)
  end

  def update_params
    params.require(:invitation).permit(:attending)
  end

end

class UserEventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def received

    event_type = params[:type] || "EventTypeUnknown"
    unless params[:user_id].nil?
      user = User.find_by(id:params[:user_id])
      if event_type == "UserAuthenticated"
        helpers.processUserAuthenticatedEvent(user)
      elsif event_type == "UserPaidBill"
        helpers.processUserPaidBillEvent(user, params)
      elsif event_type == "UserMadeDeposityIntoSavingsAccount"
        helpers.processUserMadeDeposityIntoSavingsAccountEvent(user, params)
      end
    end

    render json: user.to_json
  end

end

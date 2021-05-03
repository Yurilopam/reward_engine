class UserEventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def received

    event_type = params[:type] || "EventTypeUnknown"
    unless params[:user_id].nil?
      UserEventsService.new.process_user_event(event_type, params)
    end

    render json: { status: "ok"}
  end

end

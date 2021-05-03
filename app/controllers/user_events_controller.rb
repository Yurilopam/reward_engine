class UserEventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def initialize
    @user_events_service = ServiceComponent.instance.provides_user_events_service
    super
  end

  def received
    event_type = params[:type] || "EventTypeUnknown"
    unless params[:user_id].nil?
      @user_events_service.process_user_event(event_type, params)
    end
    render json: { status: "ok"}
  end

end

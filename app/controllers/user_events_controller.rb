class UserEventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def received

    event_type = params[:type] || "EventTypeUnknown"
    unless params[:user_id].nil?
      UserEventTypeFactory.new.get(event_type).process(params)
    end

    render json: { status: "ok"}
  end

end

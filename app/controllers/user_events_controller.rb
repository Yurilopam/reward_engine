class UserEventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def initialize
    @user_events_service = ServiceComponent.instance.provides_user_events_service
    super
  end

  def received
    if params[:user_id].nil? || params[:type].nil?
      return error_result 'Missing request params'
    end

    event_type = params[:type]

    @user_events_service.process_user_event(event_type, params)

    render json: success_result
  end

  private

    def error_result( message = '' )
      { status: "ERROR", message: message }
    end

    def success_result
      { status: "SUCCESS" }
    end

end

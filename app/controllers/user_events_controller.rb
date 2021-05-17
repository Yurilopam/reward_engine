Import = Dry::AutoInject(ServiceComponent)

class UserEventsController < ApplicationController
  include Import[:user_events_service]
  skip_before_action :verify_authenticity_token

  def received

    return error_result 'Missing request params' if params[:user_id].nil? || params[:type].nil?

    event_type = params[:type]

    render json: user_events_service.process_user_event(event_type, params)

  end

  private

    def error_result( message = '' )
      { status: "ERROR", message: message }
    end

end

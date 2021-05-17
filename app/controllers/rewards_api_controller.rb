Import = Dry::AutoInject(ServiceComponent)

class RewardsApiController < ApplicationController
  include Import[:rewards_api_service]

  def get_possible_rewards

    return error_result 'Missing user_id param' if params[:user_id].nil?

    user_id = params[:user_id]

    render json: rewards_api_service.get_available_rewards_list(user_id)

  end

  private

    def error_result( message = '' )
      { status: "ERROR", message: message }
    end

end

class RewardsApiController < ApplicationController

  def initialize
    @rewards_api_service = ServiceComponent.instance.provides_rewards_api_service
    super
  end

  def get_possible_rewards

    if params[:user_id].nil?
      return error_result 'Missing user_id param'
    end

    user_id = params[:user_id]

    render json: @rewards_api_service.get_available_rewards_list(user_id)

  end

  private

    def error_result( message = '' )
      { status: "ERROR", message: message }
    end

end

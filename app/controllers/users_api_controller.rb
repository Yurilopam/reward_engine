Import = Dry::AutoInject(ServiceComponent)

class UsersApiController < ApplicationController
  include Import[:users_api_service]
  skip_before_action :verify_authenticity_token

  def redeems

    return error_result 'Missing request params' if params[:user_id].nil? || params[:redeemed_reward_id].nil?

    user_id = params[:user_id]
    redeemed_reward_id = params[:redeemed_reward_id]

    render json: users_api_service.redeem_user_reward(user_id, redeemed_reward_id)

  end

  private

    def error_result( message = '' )
      { status: "ERROR", message: message }
    end

end

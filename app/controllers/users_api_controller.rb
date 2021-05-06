class UsersApiController < ApplicationController
  skip_before_action :verify_authenticity_token

  def initialize
    @users_api_service = ServiceComponent.provides_users_api_service
    super
  end

  def redeems

    if params[:user_id].nil? || params[:redeemed_reward_id].nil?
      return error_result 'Missing request params'
    end

    user_id = params[:user_id]
    redeemed_reward_id = params[:redeemed_reward_id]

    render json: @users_api_service.redeem_user_reward(user_id, redeemed_reward_id)

  end

  private

    def error_result( message = '' )
      { status: "ERROR", message: message }
    end

end

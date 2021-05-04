class UsersApiController < ApplicationController
  skip_before_action :verify_authenticity_token

  def redeems

    if params[:user_id].nil?
      return error_result 'Missing user_id param'
    end

    user = User.find_by(id:params[:user_id])
    redeemed_reward = Reward.find_by(id:params[:redeemed_reward_id])
    if user.total_score >= redeemed_reward.cost
      user.total_score -= redeemed_reward.cost
      user.save
    end

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

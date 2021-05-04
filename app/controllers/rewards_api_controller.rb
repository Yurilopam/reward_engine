class RewardsApiController < ApplicationController

  def getPossibleRewards

    if params[:user_id].nil?
      return error_result 'Missing user_id param'
    end

    user = User.find_by(id:params[:user_id])
    rewards = Reward.where("cost <= ?", user.total_score)

    if rewards.nil?
      return error_result 'No reward available for current user'
    end

    render json: rewards.to_json

  end

  private

    def error_result( message = '' )
      { status: "ERROR", message: message }
    end

end

class RewardsApiController < ApplicationController

  def getPossibleRewards

    unless params[:user_id].nil?
      user = User.find_by(id:params[:user_id])
      rewards = Reward.where("cost <= ?", user.total_score)
      unless rewards.nil?
        render json: rewards.to_json
      end
    end
  end

end

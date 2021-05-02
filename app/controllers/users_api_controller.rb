class UsersApiController < ApplicationController
  skip_before_action :verify_authenticity_token

  def redeems
    puts params
    unless params[:user_id].nil?
      user = User.find_by(id:params[:user_id])
      redeemed_reward = Reward.find_by(id:params[:redeemed_reward_id])
      if user.total_score >= redeemed_reward.cost
        user.total_score -= redeemed_reward.cost
        user.save
      end
      render json: user.to_json
    end
  end
end

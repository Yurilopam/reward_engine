class UsersApiService

  def initialize(user, reward)
    @user = user
    @reward = reward
  end

  def redeem_user_reward(user_id, redeemed_reward_id)
    user = @user.find_by(id: user_id)

    if user.nil?
      return error_result "User not found"
    end

    redeemed_reward = @reward.find_by(id: redeemed_reward_id)

    if redeemed_reward.nil?
      return error_result "Reward not found"
    end

    if user.total_score < redeemed_reward.cost
      return error_result 'User hasnt enough points to redeem the reward'
    end

    user.total_score -= redeemed_reward.cost
    user.save
    success_result
  end

  private

    def error_result( message = '' )
      { status: "ERROR", message: message }
    end

    def success_result
      { status: "SUCCESS" }
    end

end
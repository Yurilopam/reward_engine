class RewardsApiService

  def initialize(user, reward)
    @user = user
    @reward = reward
  end

  def get_available_rewards_list(user_id)
    user = @user.find_by(id: user_id)

    if user.nil?
      return error_result 'User not find to retrieve rewards'
    end

    rewards = @reward.where("cost <= ?", user.total_score)

    if rewards.nil? || rewards.empty?
      return error_result 'No reward available for current user'
    end

    rewards
  end

  private

    def error_result( message = '' )
      { status: "ERROR", message: message }
    end

end
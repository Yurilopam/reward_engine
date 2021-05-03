class UserEvents::UserAuthenticatedEvent

  def process(params)
    user = User.find_by(id:params[:user_id])
    if user.last_login_date == Date.current
      return
    elsif Date.current - user.last_login_date > 1
      user.login_streak = 0
      user.last_login_date = Date.current
    else
      if (user.login_streak + 1) % 7 == 0
        user.total_score += 200
      end
      user.login_streak += 1
      user.last_login_date = Date.current
    end
    user.save
  end

end
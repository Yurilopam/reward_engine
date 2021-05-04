class UserEvents::AuthenticatedEventHandler

  def initialize(user_model, date)
    @user_model = user_model
    @date = date
  end

  def call(params)
    user = @user_model.find_by(id:params[:user_id])

    if user.last_login_date == @date.current
      return { message: "User already authenticated today."}
    end

    if @date.current - user.last_login_date > 1
      user.login_streak = 0
      user.last_login_date = @date.current
      response = { message: "User login streak reset and last login date set as today."}
    else
      if (user.login_streak + 1) % 7 == 0
        user.total_score += 200
      end
      user.login_streak += 1
      user.last_login_date = @date.current

      response = { message: "User login streak raised by 1 and last login date set as today."}
    end
    user.save

    response
  end

end
class UserEvents::AuthenticatedEventHandler

  def initialize(user_model, date)
    @user_model = user_model
    @date = date
  end

  def call(params)
    user = @user_model.find_by(id:params[:user_id])

    return error_result "User not found" if user.nil?
    return error_result "User already authenticated today." if user.last_login_date == @date.current

    if @date.current - user.last_login_date > 1
      user.login_streak = 0
      user.last_login_date = @date.current
      response_message = "User login streak reset and last login date set as today."
    else
      user.total_score += 200 if (user.login_streak + 1) % 7 == 0
      user.login_streak += 1
      user.last_login_date = @date.current

      response_message = "User login streak raised by 1 and last login date set as today."
    end
    user.save

    success_result response_message
  end

  private

    def error_result( message = '' )
      { status: "ERROR", message: message }
    end

    def success_result(message = '')
      { status: "SUCCESS", message: message }
    end

end
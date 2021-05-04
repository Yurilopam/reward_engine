class UserEvents::PaidBillEventHandler

  def initialize(user)
    @user_model = user
  end

  def call(params)
    payment_due_date = params[:payment_due_date]
    payment_date = params[:payment_date]
    payment_amount = params[:payment_amount]
    if payment_due_date.nil? && payment_date.nil? && payment_amount.nil?
      return error_result 'Missing payment params'
    end

    if payment_date <= payment_due_date
      user = @user_model.find_by(id:params[:user_id])
      earned_points = ((payment_amount.to_i - payment_amount.to_i % 10)/10) * 50
      user.total_score += earned_points
      user.save
      success_result
    end

  end

  private

    def error_result( message = '' )
      { status: "ERROR", message: message }
    end

    def success_result
      { status: "SUCCESS" }
    end

end
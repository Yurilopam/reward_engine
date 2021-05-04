class UserEvents::PaidBillEventHandler

  def initialize(user)
    @user_model = user
  end

  def call(params)
    payment_due_date = params[:payment_due_date]
    payment_date = params[:payment_date]
    payment_amount = params[:payment_amount]
    unless payment_due_date.nil? && payment_date.nil? && payment_amount.nil?
      if payment_date <= payment_due_date
        user = @user_model.find_by(id:params[:user_id])
        earned_points = ((payment_amount.to_i - payment_amount.to_i % 10)/10) * 50
        user.total_score += earned_points
        user.save
        { message: "User earned points" }
      end
    end
  end

end
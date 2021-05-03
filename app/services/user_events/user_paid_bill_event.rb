class UserPaidBillEvent

  def process(params)
    payment_due_date = params[:payment_due_date]
    payment_date = params[:payment_date]
    payment_amount = params[:payment_amount]
    unless payment_due_date.nil? && payment_date.nil? && payment_amount.nil?
      user = User.find_by(id:params[:user_id])
      if payment_date <= payment_due_date
        earned_points = ((payment_amount.to_i - payment_amount.to_i % 10)/10) * 50
        user.total_score += earned_points
        user.save
      end
    end
  end

end
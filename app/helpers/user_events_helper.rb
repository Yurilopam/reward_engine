require 'httparty'
require 'json'

module UserEventsHelper

  def processUserAuthenticatedEvent(user)
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

  def processUserPaidBillEvent(user, params)
    payment_due_date = params[:payment_due_date]
    payment_date = params[:payment_date]
    payment_amount = params[:payment_amount]
    unless payment_due_date.nil? && payment_date.nil? && payment_amount.nil?
      if payment_date <= payment_due_date
        earned_points = ((payment_amount - payment_amount % 10)/10) * 50
        user.total_score += earned_points
        user.save
      end
    end
  end

  def processUserMadeDeposityIntoSavingsAccountEvent(user, params)
    user_bank = params[:user_bank]
    unless user_bank.nil?
      uri = Settings.banks[user_bank] % user.id
      unless uri.nil?
        response = HTTParty.get(uri)
        savingsAccount = JSON.parse(response.body).find do |account|
          account["type"] == "SAVINGS_ACCOUNT"
        end
        unless savingsAccount.nil?
          savings_account_balance = savingsAccount["balance"]
          if user.total_score >= 1000 && savings_account_balance > 100
            user.total_score += 1000
            user.save
          end
        end
      end
    end
  end

end

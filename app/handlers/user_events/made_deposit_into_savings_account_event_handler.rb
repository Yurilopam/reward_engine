require 'httparty'
require 'json'

class UserEvents::MadeDepositIntoSavingsAccountEventHandler

  def initialize(user_model = User, http = HTTParty)
    @user_model = user_model
    @http = http
  end

  def call(params)
    user_bank = params[:user_bank]
    unless user_bank.nil?
      user = @user_model.find_by(id:params[:user_id])
      uri = Settings.banks[user_bank] % user.id
      unless uri.nil?
        response = @http.get(uri)
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
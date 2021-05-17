class UserEvents::MadeDepositIntoSavingsAccountEventHandler

  def initialize(user_model, http, settings, json)
    @user_model = user_model
    @http = http
    @settings = settings
    @json = json
  end

  MINIMUM_TOTAL_SCORE = 1000
  MINIMUM_SAVINGS_ACCOUNT_BALANCE = 100
  POINTS_EARNED = 1000

  def call(params)
    user_bank = params[:user_bank]

    return error_result "Invalid user bank" if user_bank.nil?

    user = @user_model.find_by(id: params[:user_id])

    return error_result 'Invalid user' if user.nil?

    return error_result "User total score less than required" if user.total_score < MINIMUM_TOTAL_SCORE

    base_uri = @settings.banks[user_bank]

    return error_result 'Internal error (base uri)' if base_uri.nil?

    uri = base_uri % user.id
    response = @http.get(uri)

    savings_account = @json.parse(response.body).find do |account|
      account["type"] == "SAVINGS_ACCOUNT"
    end

    return error_result 'Invalid savings account' if savings_account.nil?

    savings_account_balance = savings_account["balance"]

    return error_result 'Invalid savings account balance' if savings_account_balance <= MINIMUM_SAVINGS_ACCOUNT_BALANCE

    user.total_score += POINTS_EARNED
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
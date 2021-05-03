class UserEventTypeFactory

  def get(event_type)
    case event_type
    when "UserAuthenticated"
      return UserAuthenticatedEvent.new
    when "UserPaidBill"
      return UserPaidBillEvent.new
    when "UserMadeDeposityIntoSavingsAccount"
      return UserMadeDeposityIntoSavingsAccountEvent.new
    else
      raise NotImplementedError
    end
  end

end
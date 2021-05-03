class UserEventsService

  def initialize

    @event_handlers = {
      UserAuthenticated: UserAuthenticatedEvent.new,
      UserPaidBill: UserPaidBillEvent.new,
      UserMadeDepositIntoSavingsAccount: UserMadeDepositIntoSavingsAccountEvent.new
    }
  end

  def process_user_event(event_type, params)
    @event_handlers[event_type].process(params)
  end

end
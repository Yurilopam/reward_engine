class UserEventsService

  def initialize
    @event_handlers = {
      UserAuthenticated: UserEvents::UserAuthenticatedEvent.new,
      UserPaidBill: UserEvents::UserPaidBillEvent.new,
      UserMadeDepositIntoSavingsAccount: UserEvents::UserMadeDepositIntoSavingsAccountEvent.new
    }
  end

  def process_user_event(event_type, params)
    @event_handlers[event_type.to_sym].process(params)
  end

end
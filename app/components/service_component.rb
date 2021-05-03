class ServiceComponent
  include Singleton

  def provides_user_events_handlers
    @user_event_handlers ||= {
      UserAuthenticated: UserEvents::AuthenticatedEventHandler.new,
      UserPaidBill: UserEvents::PaidBillEventHandler.new,
      UserMadeDepositIntoSavingsAccount: UserEvents::MadeDepositIntoSavingsAccountEventHandler.new
    }
  end

  def provides_user_events_service
    @user_events_service ||= UserEventsService.new provides_user_events_handlers
  end

end
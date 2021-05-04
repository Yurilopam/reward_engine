class ServiceComponent
  include Singleton

  def initialize
    @user_event_handler_component = UserEventsHandlerComponent.instance
  end

  def provides_user_events_handlers
    @user_event_handlers ||= {
      UserAuthenticated: @user_event_handler_component.provides_authenticated_event_handler,
      UserPaidBill: UserEvents::PaidBillEventHandler.new,
      UserMadeDepositIntoSavingsAccount: UserEvents::MadeDepositIntoSavingsAccountEventHandler.new
    }
  end

  def provides_user_events_service
    @user_events_service ||= UserEventsService.new provides_user_events_handlers
  end

end
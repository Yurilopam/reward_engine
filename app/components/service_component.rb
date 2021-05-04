class ServiceComponent
  include Singleton

  def initialize
    @user_event_handler_component = UserEventsHandlerComponent.instance
  end

  def provides_user_events_handlers
    @user_event_handlers ||= {
      UserAuthenticated: @user_event_handler_component.provides_authenticated_event_handler,
      UserPaidBill: @user_event_handler_component.provides_paid_bill_event_handler,
      UserMadeDepositIntoSavingsAccount: @user_event_handler_component.provides_made_deposit_into_savings_account_event_handler
    }
  end

  def provides_user_events_service
    @user_events_service ||= UserEventsService.new provides_user_events_handlers
  end

end
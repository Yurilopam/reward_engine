class UserEventsHandlerComponent
  include Singleton

  def provides_authenticated_event_handler
    @authenticated_event_handler ||= UserEvents::AuthenticatedEventHandler.new User, Date
  end

  def provides_paid_bill_event_handler
    @paid_bill_event_handler ||= UserEvents::PaidBillEventHandler.new User
  end

end
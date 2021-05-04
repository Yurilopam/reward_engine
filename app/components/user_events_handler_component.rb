class UserEventsHandlerComponent
  include Singleton

  def provides_authenticated_event_handler
    @authenticated_event_handler ||= UserEvents::AuthenticatedEventHandler.new User, Date
  end

end
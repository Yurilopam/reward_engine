class UserEventsService

  def initialize(event_handlers)
    @event_handlers = event_handlers
  end

  def process_user_event(event_type, params)
    @event_handlers[event_type.to_sym]&.call(params)
  end

end
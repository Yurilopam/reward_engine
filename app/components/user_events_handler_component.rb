require 'httparty'
require 'json'

class UserEventsHandlerComponent
  extend Dry::Container::Mixin

  register(:authenticated_event_handler, UserEvents::AuthenticatedEventHandler.new(User, Date))
  register(:paid_bill_event_handler, UserEvents::PaidBillEventHandler.new(User))
  register(:made_deposit_into_savings_account_event_handler, UserEvents::MadeDepositIntoSavingsAccountEventHandler.new(User, HTTParty, Settings, JSON))

end
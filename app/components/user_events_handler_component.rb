require 'httparty'
require 'json'

class UserEventsHandlerComponent
  class << self

    def provides_authenticated_event_handler
      @authenticated_event_handler ||= UserEvents::AuthenticatedEventHandler.new User, Date
    end

    def provides_paid_bill_event_handler
      @paid_bill_event_handler ||= UserEvents::PaidBillEventHandler.new User
    end

    def provides_made_deposit_into_savings_account_event_handler
      @made_deposit_into_savings_account_event_handler ||= UserEvents::MadeDepositIntoSavingsAccountEventHandler.new User, HTTParty, Settings, JSON
    end

  end
end
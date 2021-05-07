require 'rails_helper'
require 'httparty'
require 'json'

RSpec.describe UserEventsHandlerComponent do

  before(:all) do
    @user = double(User)
    @date = double(Date)
    @httparty = double(HTTParty)
    @settings = double(Settings)
    @json = double(JSON)
    @subject = UserEventsHandlerComponent
  end

  context 'when provides_authenticated_event_handler() method is called' do
    it 'should return a new instance of AuthenticatedEventHandler' do
      result = @subject.provides_authenticated_event_handler
      expect(result.class).to eq (UserEvents::AuthenticatedEventHandler.new @user, @date).class
    end
  end

  context 'when provides_authenticated_event_handler() method is called' do
    it 'should return a new instance of AuthenticatedEventHandler' do
      result = @subject.provides_paid_bill_event_handler
      expect(result.class).to eq (UserEvents::PaidBillEventHandler.new @user).class
    end
  end

  context 'when provides_authenticated_event_handler() method is called' do
    it 'should return a new instance of AuthenticatedEventHandler' do
      result = @subject.provides_made_deposit_into_savings_account_event_handler
      expect(result.class).to eq (UserEvents::MadeDepositIntoSavingsAccountEventHandler.new @user, @httparty, @settings, @json ).class
    end
  end
end
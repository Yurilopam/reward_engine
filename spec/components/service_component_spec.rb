require 'rails_helper'

RSpec.describe ServiceComponent do

  before(:all) do
    @subject = ServiceComponent.instance
  end

  context 'Given a instance ' do
    context 'when provides_user_events_handlers() method is called' do
      it 'should return map of user events handlers' do
        result = @subject.provides_user_events_handlers
        expected_keys = [ :UserAuthenticated, :UserPaidBill, :UserMadeDepositIntoSavingsAccount ]
        expected_values = [ UserEvents::AuthenticatedEventHandler.new.class,
                            UserEvents::PaidBillEventHandler.new.class,
                            UserEvents::MadeDepositIntoSavingsAccountEventHandler.new.class ]

        expect(result.keys.size).to eq 3
        expect(result.keys).to eq expected_keys
        expect(result.values.map { |item| item.class }).to eq expected_values
      end
    end

    context 'when provides_user_events_service() method is called' do
      it 'should return a new instance of UserEventsService' do
        result = @subject.provides_user_events_service
        expect(result.class).to eq UserEventsService
      end
    end
  end
end
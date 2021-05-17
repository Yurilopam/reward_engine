require 'rails_helper'

RSpec.describe ServiceComponent do

  before(:all) do
    @subject = ServiceComponent
    @user_events_handler_component_mock = UserEventsHandlerComponent
  end

  context 'Given a instance ' do
    context 'when resolve(user_events_handlers) method is called' do
      it 'should return map of user events handlers' do
        result = @subject.resolve(:user_event_handlers)
        expected_keys = [ :UserAuthenticated, :UserPaidBill, :UserMadeDepositIntoSavingsAccount ]
        expected_values = [ @user_events_handler_component_mock.resolve(:authenticated_event_handler).class,
                            @user_events_handler_component_mock.resolve(:paid_bill_event_handler).class,
                            @user_events_handler_component_mock.resolve(:made_deposit_into_savings_account_event_handler).class ]

        expect(result.keys.size).to eq 3
        expect(result.keys).to eq expected_keys
        expect(result.values.map { |item| item.class }).to eq expected_values
      end
    end

    context 'when resolve(user_events_service) method is called' do
      it 'should return a new instance of UserEventsService' do
        result = @subject.resolve(:user_events_service)
        expect(result.class).to eq UserEventsService
      end
    end

    context 'when resolve(users_api_service) method is called' do
      it 'should return a new instance of UsersApiService' do
        result = @subject.resolve(:users_api_service)
        expect(result.class).to eq UsersApiService
      end
    end

    context 'when resolve(rewards_api_service) method is called' do
      it 'should return a new instance of RewardsApiService' do
        result = @subject.resolve(:rewards_api_service)
        expect(result.class).to eq RewardsApiService
      end
    end

  end
end
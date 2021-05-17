require 'rails_helper'

RSpec.describe UserEventsService do
  before(:each) do
    @authenticated_event_handler = double(UserEvents::AuthenticatedEventHandler)
    @event_handlers_mock = double(ServiceComponent.resolve(:user_event_handlers))
    @subject = UserEventsService.new @event_handlers_mock
  end

  context 'Given a event_type and params for process_user_event()' do
    context 'when the method is called' do
      before(:each) do
        @event_type_mock = "UserAuthenticated"
        @params_mock = "params_mock"
        allow(@event_handlers_mock).to receive(:[]).with(@event_type_mock.to_sym).and_return(@authenticated_event_handler)
        allow(@authenticated_event_handler).to receive(:call).with(@params_mock)
      end
      it 'should execute call method' do
        result = @subject.process_user_event(@event_type_mock, @params_mock)
        expected_result = nil

        expect(result).to eq expected_result
        expect(@event_handlers_mock).to have_received(:[]).with(@event_type_mock.to_sym).exactly(1).times.ordered
        expect(@authenticated_event_handler).to have_received(:call).with(@params_mock).exactly(1).times.ordered
      end
    end
  end
end
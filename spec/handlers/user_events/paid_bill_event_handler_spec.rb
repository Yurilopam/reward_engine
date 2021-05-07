require 'rails_helper'

RSpec.describe UserEvents::PaidBillEventHandler do

  before(:each) do
    @user_id_mock = 1
    @user_mock = double(User)
    @user_model_mock = double(User)
    @subject = UserEvents::PaidBillEventHandler.new @user_model_mock
  end

  context 'Given a params for the call() method' do

    before(:each) do
      allow(@user_model_mock).to receive(:find_by).with({ id: @user_id_mock }).and_return(@user_mock)
    end

    context 'when payment params is null' do
      before(:each) do
        @params_mock = { payment_due_date: nil, payment_date: nil, payment_amount: nil }

      end
      it "should return error" do
        result = @subject.call @params_mock
        expected_result = { message: "Missing payment params", status: "ERROR" }

        expect(result).to eq expected_result
      end
    end

    context 'when payment params is not null' do

      context 'and user is null' do
        before(:each) do
          @date_current = Date.current
          @payment_amount_mock = 867
          @params_mock = { user_id: @user_id_mock, payment_due_date: @date_current, payment_date: @date_current, payment_amount: @payment_amount_mock }
          allow(@user_model_mock).to receive(:find_by).with({ id: @user_id_mock }).and_return(nil)
        end
        it 'should return error message' do
          result = @subject.call @params_mock
          expected_result = { message: "User not found", status: "ERROR" }

          expect(result).to eq expected_result
        end
      end

      context 'and user paid bill before or at expire date ' do
        before(:each) do
          @date_current = Date.current
          @payment_amount_mock = 867
          @initial_total_score_mock = 0
          @final_total_score_mock = 4300

          @params_mock = { user_id: @user_id_mock, payment_due_date: @date_current, payment_date: @date_current, payment_amount: @payment_amount_mock }

          allow(@user_mock).to receive(:total_score).and_return(@initial_total_score_mock)

          allow(@user_mock).to receive(:total_score=).with(@final_total_score_mock)

          allow(@user_mock).to receive(:save)
        end
        it 'should give user points based on the total payment amount ' do
          result = @subject.call @params_mock
          expected_result = { status: "SUCCESS" }

          expect(result).to eq expected_result
          expect(@user_model_mock).to have_received(:find_by).with({ id: @user_id_mock }).exactly(1).times.ordered
          expect(@user_mock).to have_received(:total_score=).with(@final_total_score_mock).exactly(1).times.ordered
          expect(@user_mock).to have_received(:save).exactly(1).times.ordered
        end
      end
    end
  end
end
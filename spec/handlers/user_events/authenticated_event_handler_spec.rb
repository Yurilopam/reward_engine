require 'rails_helper'

RSpec.describe UserEvents::AuthenticatedEventHandler do

  before(:each) do
    @user_id_mock = 1
    @user_mock = double(User)
    @params_mock = { user_id: @user_id_mock }
    @user_model_mock = double(User)
    @date_mock = double(Date)
    @date_current_mock = Date.current
    @subject = UserEvents::AuthenticatedEventHandler.new @user_model_mock, @date_mock
  end

  context 'Given a params for the call() method' do

    before(:each) do
      allow(@user_model_mock).to receive(:find_by).with({ id: @user_id_mock }).and_return(@user_mock)
      allow(@date_mock).to receive(:current).and_return(@date_current_mock)
    end

    context 'when user last login date is equal to current date' do
      before(:each) do
        allow(@user_mock).to receive(:last_login_date).and_return(@date_current_mock)
      end
      it 'should return user already authenticated today as result' do
        result = @subject.call @params_mock
        expected_result = { message: "User already authenticated today." , status: "ERROR"}

        expect(result).to eq expected_result
      end
    end

    context 'when more than a day has passed since the last login' do
      before(:each) do
        @user_last_login_date_mock = Date.new(2021, 5, 1)
        allow(@user_mock).to receive(:last_login_date).and_return(@user_last_login_date_mock)

        @login_streak_mock = 0
        allow(@user_mock).to receive(:login_streak=).with(@login_streak_mock)
        allow(@user_mock).to receive(:last_login_date=).with(@date_current_mock)

        allow(@user_mock).to receive(:save)
      end
      it 'should reset the streak, set the last login date to current date and save the user' do
        result = @subject.call @params_mock
        expected_result = { message: "User login streak reset and last login date set as today.", status: "SUCCESS" }

        expect(result).to eq expected_result
        expect(@user_mock).to have_received(:login_streak=).with(@login_streak_mock).exactly(1).times.ordered
        expect(@user_mock).to have_received(:last_login_date=).with(@date_current_mock).exactly(1).times.ordered
        expect(@user_mock).to have_received(:save).exactly(1).times.ordered
      end
    end

    context 'when user has logged a day ago ' do
      before(:each) do
        @user_login_streak_before_mock = 1
        allow(@user_mock).to receive(:login_streak).and_return(@user_login_streak_before_mock)
        allow(@user_mock).to receive(:last_login_date).and_return(@date_current_mock - 1)

        @user_login_streak_after_mock = 2
        allow(@user_mock).to receive(:login_streak=).with(@user_login_streak_after_mock)
        allow(@user_mock).to receive(:last_login_date=).with(@date_current_mock)

        allow(@user_mock).to receive(:save)
      end
      it 'should increase login streak and update last login date' do
        result = @subject.call @params_mock
        expected_result = { message: "User login streak raised by 1 and last login date set as today.", status: "SUCCESS" }

        expect(result).to eq expected_result
        expect(@user_mock).to have_received(:login_streak=).with(@user_login_streak_after_mock).exactly(1).times.ordered
        expect(@user_mock).to have_received(:last_login_date=).with(@date_current_mock).exactly(1).times.ordered
        expect(@user_mock).to have_received(:save).exactly(1).times.ordered
      end
    end

    context 'when user has logged a day ago and achieved seven days streak' do
      before(:each) do
        @user_login_streak_before_mock = 6
        @user_login_streak_after_mock = 7
        @user_total_score_before_mock = 0
        @user_total_score_after_mock = 200

        allow(@user_mock).to receive(:login_streak).and_return(@user_login_streak_before_mock)
        allow(@user_mock).to receive(:last_login_date).and_return(@date_current_mock - 1)
        allow(@user_mock).to receive(:total_score).and_return(@user_total_score_before_mock)

        allow(@user_mock).to receive(:login_streak=).with(@user_login_streak_after_mock)
        allow(@user_mock).to receive(:last_login_date=).with(@date_current_mock)
        allow(@user_mock).to receive(:total_score=).with(@user_total_score_after_mock)

        allow(@user_mock).to receive(:save)
      end

      it 'should add points to the User and increase login streak and update last login date' do
        result = @subject.call @params_mock
        expected_result = { message: "User login streak raised by 1 and last login date set as today.", status: "SUCCESS" }

        expect(result).to eq expected_result
        expect(@user_mock).to have_received(:login_streak=).with(@user_login_streak_after_mock).exactly(1).times.ordered
        expect(@user_mock).to have_received(:last_login_date=).with(@date_current_mock).exactly(1).times.ordered
        expect(@user_mock).to have_received(:save).exactly(1).times.ordered
      end
    end

  end

end
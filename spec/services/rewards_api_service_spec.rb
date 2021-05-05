require 'rails_helper'

RSpec.describe RewardsApiService do
  before do
    @user_id_mock = 1
    @user_mock = double(User)
    @reward_mock = double(Reward)
    @reward_result_mock = double(Reward)
    @user_model_mock = double(User)
    @reward_model_mock = double(Reward)
    @subject = RewardsApiService.new @user_model_mock, @reward_model_mock
  end

  context 'Given a user_id for the get_available_rewards_list() method' do
    before(:each) do
      @reward_where_conditional_mock = "cost <= ?"
      @user_total_score = 1000
      allow(@user_model_mock).to receive(:find_by).with({ id: @user_id_mock }).and_return(@user_mock)
      allow(@user_mock).to receive(:total_score).and_return(@user_total_score)
    end
    context 'when user has available rewards to redeem ' do
      before(:each) do
      allow(@reward_model_mock).to receive(:where).with(@reward_where_conditional_mock, @user_total_score).and_return([@reward_result_mock])
      end
      it 'should return a list of available rewards' do
        result = @subject.get_available_rewards_list(@user_id_mock)
        expected_result = [@reward_result_mock]

        expect(result).to eq expected_result
        expect(@user_model_mock).to have_received(:find_by).with({ id: @user_id_mock }).exactly(1).times.ordered
        expect(@user_mock).to have_received(:total_score).exactly(1).times.ordered
        expect(@reward_model_mock).to have_received(:where).with(@reward_where_conditional_mock, @user_total_score).exactly(1).times.ordered
      end
    end

    context 'when user doesnt have available rewards to redeem' do
      before(:each) do
        allow(@reward_model_mock).to receive(:where).with(@reward_where_conditional_mock, @user_total_score).and_return([])
      end
      it 'should return error message' do
        result = @subject.get_available_rewards_list(@user_id_mock)
        expected_result =  { message: "No reward available for current user", status: "ERROR" }

        expect(result).to eq expected_result
        expect(@user_model_mock).to have_received(:find_by).with({ id: @user_id_mock }).exactly(1).times.ordered
        expect(@user_mock).to have_received(:total_score).exactly(1).times.ordered
        expect(@reward_model_mock).to have_received(:where).with(@reward_where_conditional_mock, @user_total_score).exactly(1).times.ordered

      end
    end

    context 'when the list of rewards return null' do
      before(:each) do
        allow(@reward_model_mock).to receive(:where).with(@reward_where_conditional_mock, @user_total_score).and_return(nil)
      end
      it 'should return error message' do
        result = @subject.get_available_rewards_list(@user_id_mock)
        expected_result =  { message: "No reward available for current user", status: "ERROR" }

        expect(result).to eq expected_result
        expect(@user_model_mock).to have_received(:find_by).with({ id: @user_id_mock }).exactly(1).times.ordered
        expect(@user_mock).to have_received(:total_score).exactly(1).times.ordered
        expect(@reward_model_mock).to have_received(:where).with(@reward_where_conditional_mock, @user_total_score).exactly(1).times.ordered

      end
    end
  end
end
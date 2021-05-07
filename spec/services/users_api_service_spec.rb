require 'rails_helper'

RSpec.describe UsersApiService do
  before(:each) do
    @user_id_mock = 1
    @redeemed_reward_id_mock = 1
    @user_mock = double(User)
    @reward_mock = double(Reward)
    @user_model_mock = double(User)
    @reward_model_mock = double(Reward)
    @subject = UsersApiService.new @user_model_mock, @reward_model_mock
  end


  context 'Given a user_id and a redeemed_reward_id for the redeem_user_reward() method' do
    before(:each) do
      allow(@user_model_mock).to receive(:find_by).with({ id: @user_id_mock }).and_return(@user_mock)
      allow(@reward_model_mock).to receive(:find_by).with({ id: @redeemed_reward_id_mock }).and_return(@reward_mock)
    end

    context 'when user is null' do
      before(:each) do
        allow(@user_model_mock).to receive(:find_by).with({ id: @user_id_mock }).and_return(nil)
      end
      it 'should return error message' do
        result = @subject.redeem_user_reward(@user_id_mock, @redeemed_reward_id_mock)
        expected_result = { message: "User not found", status: "ERROR" }

        expect(result).to eq expected_result
      end
    end

    context 'when reward is null' do
      before(:each) do
        allow(@reward_model_mock).to receive(:find_by).with({ id: @redeemed_reward_id_mock }).and_return(nil)
      end
      it 'should return error message' do
        result = @subject.redeem_user_reward(@user_id_mock, @redeemed_reward_id_mock)
        expected_result = { message: "Reward not found", status: "ERROR" }

        expect(result).to eq expected_result
      end
    end


    context 'when user has less points than the reward to redeem ' do
      before do
        @user_total_cost_mock = 1000
        @reward_cost_mock = 1500
        allow(@user_mock).to receive(:total_score).and_return(@user_total_cost_mock)
        allow(@reward_mock).to receive(:cost).and_return(@reward_cost_mock)
      end
      it 'should return error message' do
        result = @subject.redeem_user_reward(@user_id_mock, @redeemed_reward_id_mock)
        expected_result = { message: "User hasnt enough points to redeem the reward", status: "ERROR" }

        expect(result).to eq expected_result
        expect(@user_model_mock).to have_received(:find_by).with({ id: @user_id_mock }).exactly(1).times.ordered
        expect(@reward_model_mock).to have_received(:find_by).with({ id: @redeemed_reward_id_mock }).exactly(1).times.ordered
        expect(@user_mock).to have_received(:total_score).exactly(1).times.ordered
        expect(@reward_mock).to have_received(:cost).exactly(1).times.ordered
      end
    end

    context 'when user has points to redeem reward' do
      before do
        @user_total_cost_mock = 2000
        @reward_cost_mock = 1500
        @user_final_total_cost_mock = 500
        allow(@user_mock).to receive(:total_score).and_return(@user_total_cost_mock)
        allow(@reward_mock).to receive(:cost).and_return(@reward_cost_mock)

        allow(@user_mock).to receive(:total_score=).and_return(@user_final_total_cost_mock)

        allow(@user_mock).to receive(:save)
      end
      it 'should update user and return success message' do
        result = @subject.redeem_user_reward(@user_id_mock, @redeemed_reward_id_mock)
        expected_result = { status: "SUCCESS" }

        expect(result).to eq expected_result
        expect(@user_model_mock).to have_received(:find_by).with({ id: @user_id_mock }).exactly(1).times.ordered
        expect(@reward_model_mock).to have_received(:find_by).with({ id: @redeemed_reward_id_mock }).exactly(1).times.ordered
        expect(@user_mock).to have_received(:total_score).exactly(2).times.ordered
      end

    end

  end

end
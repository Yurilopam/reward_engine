require 'rails_helper'
require 'httparty'
require 'json'

RSpec.describe UserEvents::MadeDepositIntoSavingsAccountEventHandler do

  before(:each) do
    @user_id_mock = 1
    @user_bank_mock = "BANK_LOPAM"
    @json_response_mock = [{ "type" => "SAVINGS_ACCOUNT", "balance" => 2000 }]
    @http_response_body_mock = '[{ "type": "SAVINGS_ACCOUNT", "balance": "2000" }]'
    @http_response_mock = double(HTTParty::Response)
    @user_mock = double(User)
    @user_model_mock = double(User)
    @httparty_mock = double(HTTParty)
    @settings_mock = double(Settings)
    @json_mock = double(JSON)
    @subject = UserEvents::MadeDepositIntoSavingsAccountEventHandler.new @user_model_mock, @httparty_mock, @settings_mock, @json_mock
  end

  context 'Given a params for the call() method' do

    before(:each) do
      allow(@user_model_mock).to receive(:find_by).with({ id: @user_id_mock }).and_return(@user_mock)
    end

    context 'when param user bank is invalid ' do

      before(:each) do
        @params_mock = { user_id: @user_id_mock, user_bank: nil }
      end

      it "should return error message" do
        result = @subject.call @params_mock
        expected_result = { message: "Invalid user bank", status: "ERROR" }

        expect(result).to eq expected_result
      end
    end

    context 'when user is null' do

      before(:each) do
        @params_mock = { user_id: nil, user_bank: "BANK_LOPAM" }
        allow(@user_model_mock).to receive(:find_by).with({ id: nil }).and_return(nil)
      end

      it 'should return error message' do
        result = @subject.call @params_mock
        expected_result = { message: "Invalid user", status: "ERROR" }

        expect(result).to eq expected_result
        expect(@user_model_mock).to have_received(:find_by).with({ id: nil }).exactly(1).times.ordered
      end
    end

    context 'when user total score is less than required ' do

      before(:each) do
        @params_mock = { user_id: @user_id_mock, user_bank: "BANK_LOPAM" }
        @total_score_less_than_required_mock = 500

        allow(@user_mock).to receive(:total_score).and_return(@total_score_less_than_required_mock)
      end

      it 'should return error message' do
        result = @subject.call @params_mock
        expected_result = { message: "User total score less than required", status: "ERROR" }

        expect(result).to eq expected_result
        expect(@user_model_mock).to have_received(:find_by).with({ id: @user_id_mock }).exactly(1).times.ordered
      end
    end

    context 'when base_uri is null' do
      before(:each) do
        @params_mock = { user_id: @user_id_mock, user_bank: @user_bank_mock }
        @initial_total_score_greater_than_required_mock = 1000
        @base_uri_mock = "base_uri_mock"

        allow(@user_mock).to receive(:total_score).and_return(@initial_total_score_greater_than_required_mock)
        allow(@settings_mock).to receive(:banks).and_return({ @user_bank_mock => nil })
      end

      it 'should return error message' do
        result = @subject.call @params_mock
        expected_result = { message: "Internal error (base uri)", status: "ERROR" }

        expect(result).to eq expected_result
        expect(@user_model_mock).to have_received(:find_by).with({ id: @user_id_mock }).exactly(1).times.ordered
        expect(@settings_mock).to have_received(:banks).exactly(1).times.ordered
      end
    end

    context 'when savings account is null' do

      before(:each) do
        @params_mock = { user_id: @user_id_mock, user_bank: @user_bank_mock }
        @initial_total_score_greater_than_required_mock = 1000
        @base_uri_mock = "base_uri_mock"
        @json_response_mock = [{ "type" => "ANOTHER_ACCOUNT", "balance" => 2000 }]

        allow(@user_mock).to receive(:total_score).and_return(@initial_total_score_greater_than_required_mock)
        allow(@settings_mock).to receive(:banks).and_return({ @user_bank_mock => @base_uri_mock })
        allow(@user_mock).to receive(:id).and_return(@user_id_mock)
        allow(@httparty_mock).to receive(:get).and_return(@http_response_mock)
        allow(@http_response_mock).to receive(:body).and_return(@http_response_body_mock)
        allow(@json_mock).to receive(:parse).and_return(@json_response_mock)
      end

      it 'should return error message' do
        result = @subject.call @params_mock
        expected_result = { message: "Invalid savings account", status: "ERROR" }

        expect(result).to eq expected_result
        expect(@user_model_mock).to have_received(:find_by).with({ id: @user_id_mock }).exactly(1).times.ordered
        expect(@settings_mock).to have_received(:banks).exactly(1).times.ordered
        expect(@httparty_mock).to have_received(:get).exactly(1).times.ordered
        expect(@json_mock).to have_received(:parse).exactly(1).times.ordered
      end

    end

    context 'when savings account balance is lower than the minimal to win points' do

      before(:each) do
        @params_mock = { user_id: @user_id_mock, user_bank: @user_bank_mock }
        @initial_total_score_greater_than_required_mock = 1000
        @base_uri_mock = "base_uri_mock"
        @final_total_score_greater_than_required_mock = 2000
        @json_response_mock = [{ "type" => "SAVINGS_ACCOUNT", "balance" => 50 }]

        allow(@user_mock).to receive(:total_score).and_return(@initial_total_score_greater_than_required_mock)
        allow(@settings_mock).to receive(:banks).and_return({ @user_bank_mock => @base_uri_mock })
        allow(@user_mock).to receive(:id).and_return(@user_id_mock)
        allow(@httparty_mock).to receive(:get).and_return(@http_response_mock)
        allow(@http_response_mock).to receive(:body).and_return(@http_response_body_mock)
        allow(@json_mock).to receive(:parse).and_return(@json_response_mock)
      end

      it 'should return error message' do
        result = @subject.call @params_mock
        expected_result = { message: "Invalid savings account balance", status: "ERROR" }

        expect(result).to eq expected_result
        expect(@user_model_mock).to have_received(:find_by).with({ id: @user_id_mock }).exactly(1).times.ordered
        expect(@settings_mock).to have_received(:banks).exactly(1).times.ordered
        expect(@httparty_mock).to have_received(:get).exactly(1).times.ordered
        expect(@json_mock).to have_received(:parse).exactly(1).times.ordered
      end
    end

    context 'when user has enough balance in his savings account and a minimum total score ' do

      before(:each) do
        @params_mock = { user_id: @user_id_mock, user_bank: @user_bank_mock }
        @initial_total_score_greater_than_required_mock = 1000
        @base_uri_mock = "base_uri_mock"
        @final_total_score_greater_than_required_mock = 2000

        allow(@user_mock).to receive(:total_score).and_return(@initial_total_score_greater_than_required_mock)
        allow(@settings_mock).to receive(:banks).and_return({ @user_bank_mock => @base_uri_mock })
        allow(@user_mock).to receive(:id).and_return(@user_id_mock)
        allow(@httparty_mock).to receive(:get).and_return(@http_response_mock)
        allow(@http_response_mock).to receive(:body).and_return(@http_response_body_mock)
        allow(@json_mock).to receive(:parse).and_return(@json_response_mock)

        allow(@user_mock).to receive(:total_score=).with(@final_total_score_greater_than_required_mock)

        allow(@user_mock).to receive(:save)
      end

      it 'should return success' do
        result = @subject.call @params_mock
        expected_result = { status: "SUCCESS" }

        expect(result).to eq expected_result
        expect(@user_model_mock).to have_received(:find_by).with({ id: @user_id_mock }).exactly(1).times.ordered
        expect(@settings_mock).to have_received(:banks).exactly(1).times.ordered
        expect(@httparty_mock).to have_received(:get).exactly(1).times.ordered
        expect(@json_mock).to have_received(:parse).exactly(1).times.ordered
        expect(@user_mock).to have_received(:total_score=).with(@final_total_score_greater_than_required_mock).exactly(1).times.ordered
        expect(@user_mock).to have_received(:save).exactly(1).times.ordered
      end
    end

  end

end
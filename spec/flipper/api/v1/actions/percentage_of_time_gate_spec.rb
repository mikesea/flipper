require 'helper'

RSpec.describe Flipper::Api::V1::Actions::PercentageOfTimeGate do
  let(:app) { build_api(flipper) }

  describe 'enable' do
    before do
      flipper[:my_feature].disable
      post '/api/v1/features/my_feature/percentage_of_time', { percentage: '10' }
    end

    it 'enables gate for feature' do
      expect(flipper[:my_feature].enabled_gate_names).to include(:percentage_of_time)
    end

    it 'returns decorated feature with gate enabled for 5% of time' do
      gate = json_response['gates'].find { |gate| gate['name'] == 'percentage_of_time' }
      expect(gate['value']).to eq(10)
    end
  end

  describe 'disable' do
    before do
      flipper[:my_feature].enable_percentage_of_time(10)
      delete '/api/v1/features/my_feature/percentage_of_time'
    end

    it 'disables gate for feature' do
      expect(flipper[:my_feature].enabled_gates).to be_empty
    end

    it 'returns decorated feature with gate disabled' do
      gate = json_response['gates'].find { |gate| gate['name'] == 'percentage_of_time' }
      expect(gate['value']).to eq(0)
    end
  end

  describe 'non-existent feature' do
    before do
      delete '/api/v1/features/my_feature/percentage_of_time'
    end

    it  '404s with correct error response when feature does not exist' do
      expect(last_response.status).to eq(404)
      expect(json_response).to eq({ 'code' => 1, 'message' => 'Feature not found.', 'more_info' => 'https://github.com/jnunemaker/flipper/tree/master/docs/api#error-code-reference' })
    end
  end

  describe 'out of range parameter percentage parameter' do
    before do
      flipper[:my_feature].disable
      post '/api/v1/features/my_feature/percentage_of_time', { percentage: '300' }
    end

    it '422s with correct error response when percentage parameter is invalid' do
      expect(last_response.status).to eq(422)
      expect(json_response).to eq({ 'code' => 3, 'message' => 'Percentage must be a positive number less than or equal to 100.', 'more_info' => 'https://github.com/jnunemaker/flipper/tree/master/docs/api#error-code-reference' })
    end
  end

  describe 'percentage parameter not an integer' do
    before do
      flipper[:my_feature].disable
      post '/api/v1/features/my_feature/percentage_of_time', { percentage: 'foo' }
    end

    it '422s with correct error response when percentage parameter is invalid' do
      expect(last_response.status).to eq(422)
      expect(json_response).to eq({ 'code' => 3, 'message' => 'Percentage must be a positive number less than or equal to 100.', 'more_info' => 'https://github.com/jnunemaker/flipper/tree/master/docs/api#error-code-reference' })
    end
  end

  describe 'missing percentage parameter' do
    before do
      flipper[:my_feature].disable
      post '/api/v1/features/my_feature/percentage_of_time'
    end

    it '422s with correct error response when percentage parameter is missing' do
      expect(last_response.status).to eq(422)
      expect(json_response).to eq({ 'code' => 3, 'message' => 'Percentage must be a positive number less than or equal to 100.', 'more_info' => 'https://github.com/jnunemaker/flipper/tree/master/docs/api#error-code-reference' })
    end
  end
end

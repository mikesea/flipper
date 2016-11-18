require 'helper'

RSpec.describe Flipper::Api::V1::Actions::ActorsGate do
  let(:app) { build_api(flipper) }

  describe 'enable' do
    let(:actor) { Flipper::Api::Actor.new("1") }

    before do
      flipper[:my_feature].disable_actor(actor)
      post '/api/v1/features/my_feature/actors', { flipper_id: actor.flipper_id }
    end

    it 'enables feature for actor' do
      expect(last_response.status).to eq(200)
      expect(flipper[:my_feature].enabled?(actor)).to be_truthy
      expect(flipper[:my_feature].enabled_gate_names).to eq([:actor])
    end

    it 'returns decorated feature with actor enabled' do
      gate = json_response['gates'].find { |gate| gate['key'] == 'actors' }
      expect(gate['value']).to eq(["1"])
    end
  end

  describe 'disable' do
    let(:actor) { Flipper::Api::Actor.new("1") }

    before do
      flipper[:my_feature].enable_actor(actor)
      delete '/api/v1/features/my_feature/actors', { flipper_id: actor.flipper_id }
    end

    it 'disables feature' do
      expect(last_response.status).to eq(200)
      expect(flipper[:my_feature].enabled?(actor)).to be_falsy
      expect(flipper[:my_feature].enabled_gate_names).to be_empty
    end

    it 'returns decorated feature with boolean gate disabled' do
      gate = json_response['gates'].find { |gate| gate['key'] == 'actors' }
      expect(gate['value']).to be_empty
    end
  end

  describe 'enable missing flipper_id parameter' do
    before do
      flipper[:my_feature].enable
      post '/api/v1/features/my_feature/actors'
    end

    it 'returns correct error response' do
      expect(last_response.status).to eq(422)
      expect(json_response).to eq({ 'code' => 4, 'message' => 'Required parameter flipper_id is missing.', 'more_info' => 'https://github.com/jnunemaker/flipper/tree/master/docs/api#error-code-reference' })
    end
  end

  describe 'disable missing flipper_id parameter' do
    before do
      flipper[:my_feature].enable
      delete '/api/v1/features/my_feature/actors'
    end

    it 'returns correct error response' do
      expect(last_response.status).to eq(422)
      expect(json_response).to eq({ 'code' => 4, 'message' => 'Required parameter flipper_id is missing.', 'more_info' => 'https://github.com/jnunemaker/flipper/tree/master/docs/api#error-code-reference' })
    end
  end

  describe 'enable nil flipper_id parameter' do
    before do
      flipper[:my_feature].enable
      post '/api/v1/features/my_feature/actors', { flipper_id: nil }
    end

    it 'returns correct error response' do
      expect(last_response.status).to eq(422)
      expect(json_response).to eq({ 'code' => 4, 'message' => 'Required parameter flipper_id is missing.', 'more_info' => 'https://github.com/jnunemaker/flipper/tree/master/docs/api#error-code-reference' })
    end
  end

  describe 'disable nil flipper_id parameter' do
    before do
      flipper[:my_feature].enable
      delete '/api/v1/features/my_feature/actors', { flipper_id: nil }
    end

    it 'returns correct error response' do
      expect(last_response.status).to eq(422)
      expect(json_response).to eq({ 'code' => 4, 'message' => 'Required parameter flipper_id is missing.', 'more_info' => 'https://github.com/jnunemaker/flipper/tree/master/docs/api#error-code-reference' })
    end
  end

  describe 'enable missing feature' do
    before do
      post '/api/v1/features/my_feature/actors'
    end

    it 'returns correct error response' do
      expect(last_response.status).to eq(404)
      expect(json_response).to eq({ 'code' => 1, 'message' => 'Feature not found.', 'more_info' => 'https://github.com/jnunemaker/flipper/tree/master/docs/api#error-code-reference' })
    end
  end

  describe 'disable missing feature' do
    before do
      delete '/api/v1/features/my_feature/actors'
    end

    it 'returns correct error response' do
      expect(last_response.status).to eq(404)
      expect(json_response).to eq({ 'code' => 1, 'message' => 'Feature not found.', 'more_info' => 'https://github.com/jnunemaker/flipper/tree/master/docs/api#error-code-reference' })
    end
  end
end

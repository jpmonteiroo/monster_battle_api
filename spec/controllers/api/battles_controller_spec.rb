# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::BattlesController', type: :request do
  let!(:monster1) do
    FactoryBot.create(:monster,
                      name: 'Monster 1',
                      attack: 40,
                      defense: 20,
                      hp: 50,
                      speed: 80,
                      imageUrl: 'https://example.com/image.jpg')
  end

  let!(:monster2) do
    FactoryBot.create(:monster,
                      name: 'Monster 2',
                      attack: 40,
                      defense: 10,
                      hp: 20,
                      speed: 10,
                      imageUrl: 'https://example.com/image.jpg')
  end

  describe 'POST /api/v1/battles' do
    it 'returns bad request if one parameter is missing' do
      post '/api/v1/battles', params: { monsterB_id: monster2.id }

      expect(response).to have_http_status(:bad_request)
      json = JSON.parse(response.body)
      expect(json['error']).to be_present
    end

    it 'returns bad request if monster does not exist' do
      post '/api/v1/battles', params: { monsterA_id: 9999, monsterB_id: monster2.id }

      expect(response).to have_http_status(:bad_request)
      json = JSON.parse(response.body)
      expect(json['error']).to be_present
    end

    it 'creates a battle and monsterA wins' do
      post '/api/v1/battles', params: {
        monsterA_id: monster1.id,
        monsterB_id: monster2.id
      }

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['battle_id']).to be_present
      expect(json['winner']['id']).to eq(monster1.id)
      expect(json['winner']['name']).to eq(monster1.name)
    end

    it 'creates a battle and monsterB wins by speed tie-breaker' do
      monstera = FactoryBot.create(:monster,
                                   name: 'Tie Monster A',
                                   attack: 40,
                                   defense: 20,
                                   hp: 50,
                                   speed: 10,
                                   imageUrl: 'https://example.com/image.jpg')

      monsterb = FactoryBot.create(:monster,
                                   name: 'Tie Monster B',
                                   attack: 40,
                                   defense: 20,
                                   hp: 50,
                                   speed: 100,
                                   imageUrl: 'https://example.com/image.jpg')

      post '/api/v1/battles', params: {
        monsterA_id: monstera.id,
        monsterB_id: monsterb.id
      }

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['winner']['id']).to eq(monsterb.id)
    end
  end

  describe 'DELETE /api/v1/battles/:id' do
    it 'deletes an existing battle' do
      battle = FactoryBot.create(:battle, monsterA: monster1, monsterB: monster2, winner_id: monster1.id)

      delete "/api/v1/battles/#{battle.id}"

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['message']).to eq('Battle deleted successfully')
      expect(Battle.exists?(battle.id)).to be_falsey
    end

    it 'returns not found when trying to delete nonexistent battle' do
      delete '/api/v1/battles/999999'

      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json['error']).to eq('Battle not found')
    end
  end
end

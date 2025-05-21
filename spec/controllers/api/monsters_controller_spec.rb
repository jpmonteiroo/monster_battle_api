# spec/controllers/api/v1/monsters_controller_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::MonstersController, type: :controller do
  describe 'GET #index' do
    it 'should get all monsters correctly' do
      FactoryBot.create(:monster, name: 'My monster Test')
      get :index, format: :json

      response_data = JSON.parse(response.body)['data']
      expect(response).to have_http_status(:ok)
      expect(response_data[0]['name']).to eq('My monster Test')
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) do
      {
        name: 'Hydra',
        attack: 70,
        defense: 40,
        hp: 200,
        speed: 30,
        imageUrl: 'https://example.com/hydra.png'
      }
    end

    let(:invalid_attributes) do
      {
        name: '',
        attack: nil,
        defense: nil
      }
    end

    context 'with valid parameters' do
      it 'creates a new monster' do
        expect {
          post :create, params: { monster: valid_attributes }, format: :json
        }.to change { Monster.count }.by(1)

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['data']['name']).to eq('Hydra')
      end
    end

    context 'with invalid parameters' do
      it 'returns error and does not create monster' do
        expect {
          post :create, params: { monster: invalid_attributes }, format: :json
        }.not_to change { Monster.count }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to include('Failed to create monster')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when monster exists' do
      it 'deletes the monster and returns ok' do
        monster = FactoryBot.create(:monster)
        delete :destroy, params: { id: monster.id }, format: :json

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Monster deleted successfully')
      end
    end

    context 'when monster does not exist' do
      it 'returns not found error' do
        delete :destroy, params: { id: -1 }, format: :json

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Monster not found')
      end
    end
  end

  describe 'POST #import' do
    it 'imports monsters from valid CSV file' do
      csv_content = <<~CSV
        name,attack,defense,hp,speed,imageUrl
        Dragon,80,50,100,60,https://example.com/dragon.jpg
        Goblin,30,10,40,20,https://example.com/goblin.jpg
      CSV

      file = Tempfile.new(['monsters', '.csv'])
      file.write(csv_content)
      file.rewind

      uploaded_file = Rack::Test::UploadedFile.new(file.path, 'text/csv')

      expect {
        post :import, params: { file: uploaded_file }, format: :json
      }.to change { Monster.count }.by(2)

      expect(response).to have_http_status(:created)
    end

    it 'returns error for missing file' do
      expect {
        post :import, params: { file: nil }, format: :json
      }.not_to change { Monster.count }

      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)['error']).to eq('File not provided')
    end

    it 'returns error for invalid CSV content' do
      csv_content = <<~CSV
        invalid,columns
      CSV

      file = Tempfile.new(['monsters', '.csv'])
      file.write(csv_content)
      file.rewind

      uploaded_file = Rack::Test::UploadedFile.new(file.path, 'text/csv')

      expect {
        post :import, params: { file: uploaded_file }, format: :json
      }.not_to change { Monster.count }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['error']).to include('Failed to import monsters')
    end
  end
end

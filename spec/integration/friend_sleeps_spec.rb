require 'swagger_helper'

describe 'Friend sleeps API' do
  let!(:current_user) { create(:user) }
  let!(:friend) { create(:user) }
  let!(:friend_last_month_sleep) do
    last_month = Time.now - 1.month
    create(:sleep, user: friend, slept_at: last_month, waked_at: last_month + 8.hour)
  end
  let!(:friend_past_week_sleeps) do
    day1 = Time.now - 6.days
    day2 = Time.now - 3.days
    day3 = Time.now - 1.days
    [
      create(:sleep, user: friend, slept_at: day1, waked_at: day1 + 8.hour),
      create(:sleep, user: friend, slept_at: day2, waked_at: day2 + 7.hour),
      create(:sleep, user: friend, slept_at: day3, waked_at: day3 + 6.hour)
    ]
  end

  # GET /api/friends/{id}/sleeps
  path '/api/friends/{id}/sleeps' do
    get 'Retrieves a friend\'s sleep records of past week' do
      tags 'Friend sleeps'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, required: true
      parameter name: :'X-API-Key', in: :header, type: :string, format: :uuid, required: true

      response '200', 'Friend\'s sleep records found' do
        schema type: :object,
          properties: {
            status: { type: :string, enum: ['ok'] },
            type: { type: :string, enum: ['Sleep'] },
            records: {
              type: :array,
              items: {
                uuid: { type: :string, format: 'uuid' },
                slept_at: { type: :string, format: 'date-time' },
                waked_at: { type: :string, format: 'date-time' },
                duration: { type: :integer },
                created_at: { type: :string, format: 'date-time' },
                updated_at: { type: :string, format: 'date-time' }
              }
            }
          }

        let(:id) { friend.id }
        let(:'X-API-Key') { current_user.api_key }

        before do
          current_user.followings << friend
        end

        run_test! do |res|
          json = JSON.parse(res.body)
          expect(json['records']).to be_a(Array)
          expect(json['records'].size).to eq(3)
          expect(json['records'][0]['uuid']).to eq(friend_past_week_sleeps[0].uuid)
          expect(json['records'][1]['uuid']).to eq(friend_past_week_sleeps[1].uuid)
          expect(json['records'][2]['uuid']).to eq(friend_past_week_sleeps[2].uuid)
          expect(json['records'][0].keys).to contain_exactly('uuid', 'slept_at', 'waked_at', 'duration', 'created_at', 'updated_at')
        end
      end

      response '401', 'Unauthorized request' do
        schema type: :object,
          properties: {
            status: { type: :string, enum: ['error'] },
            message: { type: :string, enum: ['Unauthorized request, please provide a valid api-key'] }
          }

        let(:id) { friend.id }
        let(:'X-API-Key') { 'invalid-api-key' }

        run_test!
      end

      response '400', 'Following user record not found' do
        schema type: :object,
          properties: {
            status: { type: :string, enum: ['error'] },
            message: { type: :string }
          }

        let(:id) { 1_000_000 }
        let(:'X-API-Key') { current_user.api_key }

        run_test! do |res|
          json = JSON.parse(res.body)
          expect(json['status']).to eq('error')
          expect(json['message']).to match('Couldn\'t find Friendship')
        end
      end
    end
  end
end
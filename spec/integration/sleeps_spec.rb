require 'swagger_helper'

describe 'Sleeps API' do
  let!(:user) { create(:user) }
  let!(:sleeps) { 3.times.map { create(:sleep, user: user) } }

  # PUT /api/sleeps/{uuid}
  path '/api/sleeps/{uuid}' do
    put 'Create or update a sleep record' do
      tags 'Sleeps'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :'X-API-Key', in: :heade, type: :string, format: :uuid, required: true
      parameter name: :uuid, in: :path, type: :string, format: :uuid, required: true
      parameter name: :sleep, in: :body, schema: {
        type: :object,
        properties: {
          slept_at: { type: :string, format: 'date-time', required: true },
          waked_at: { type: :string, format: 'date-time', required: true }
        }
      }

      response '200', 'Sleep record created or updated' do
        schema type: :object,
          properties: {
            status: { type: :string, enum: ['ok'] },
            type: { type: :string, enum: ['Sleep'] },
            record: {
              type: :object,
              properties: {
                uuid: { type: :string, format: 'uuid' },
                slept_at: { type: :string, format: 'date-time' },
                waked_at: { type: :string, format: 'date-time' },
                duration: { type: :integer },
                created_at: { type: :string, format: 'date-time' },
                updated_at: { type: :string, format: 'date-time' }
              }
            }
          }

        let(:uuid) { SecureRandom.uuid }
        let(:slept_at) { '2019-06-10T23:30:00+00:00' }
        let(:waked_at) { '2019-06-11T07:20:00+00:00' }
        let(:sleep) { { slept_at: slept_at, waked_at: waked_at } }
        let(:'X-API-Key') { user.api_key }

        run_test! do |res|
          json = JSON.parse(res.body)
          expect(json['status']).to eq('ok')
          expect(json['type']).to eq('Sleep')
          record = json['record']
          expect(record['uuid']).to eq(uuid)
          expect(record['slept_at']).to eq(slept_at)
          expect(record['waked_at']).to eq(waked_at)
          expect(record['duration']).to eq(waked_at.to_time - slept_at.to_time)
          expect(record['created_at'].to_time).to be_within(3).of(Time.now)
          expect(record['updated_at'].to_time).to be_within(3).of(Time.now)
        end
      end

      response '401', 'Unauthorized request' do
        schema type: :object,
          properties: {
            status: { type: :string, enum: ['error'] },
            message: { type: :string, enum: ['Unauthorized request, please provide a valid api-key'] }
          }

        let(:uuid) { SecureRandom.uuid }
        let(:slept_at) { '2019-06-10T23:30:00+00:00' }
        let(:waked_at) { '2019-06-11T07:20:00+00:00' }
        let(:sleep) { { slept_at: slept_at, waked_at: waked_at } }
        let(:'X-API-Key') { 'invalid-api-key' }

        run_test!
      end

      response '400', 'Bad request' do
        schema type: :object,
          properties: {
            status: { type: :string, enum: ['error'] },
            message: { type: :string, enum: ['param is missing or the value is empty: sleep'] }
          }

        let(:uuid) { SecureRandom.uuid }
        let(:sleep) { { } }
        let(:'X-API-Key') { user.api_key }

        run_test!
      end

      response '400', 'Bad request' do
        schema type: :object,
          properties: {
            status: { type: :string, enum: ['error'] },
            messages: { type: :array }
          }

        let(:uuid) { 'invalid-uuid-string' }
        let(:sleep) { { slept_at: 'invalid-slept_at', waked_at: 'invalid-waked_at' } }
        let(:'X-API-Key') { user.api_key }

        run_test! do |res|
          json = JSON.parse(res.body)
          expect(json['status']).to eq('error')
          expect(json['messages']).to include('Uuid must be a uuid string')
          expect(json['messages']).to include('Slept at must be a date-time string')
          expect(json['messages']).to include('Waked at must be a date-time string')
        end
      end
    end
  end

  # GET /api/sleeps
  path '/api/sleeps' do
    get 'Retrieves sleep records' do
      tags 'Sleeps'
      produces 'application/json'
      parameter name: :'X-API-Key', in: :heade, type: :string, format: :uuid, required: true

      response '200', 'Sleep records found' do
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

        let(:'X-API-Key') { user.api_key }

        run_test! do |res|
          json = JSON.parse(res.body)
          expect(json['records']).to be_a(Array)
          expect(json['records'][0]['uuid']).to eq(sleeps[0].uuid)
          expect(json['records'][1]['uuid']).to eq(sleeps[1].uuid)
          expect(json['records'][2]['uuid']).to eq(sleeps[2].uuid)
          expect(json['records'][0].keys).to contain_exactly('uuid', 'slept_at', 'waked_at', 'duration', 'created_at', 'updated_at')
        end
      end

      response '401', 'Unauthorized request' do
        schema type: :object,
          properties: {
            status: { type: :string, enum: ['error'] },
            message: { type: :string, enum: ['Unauthorized request, please provide a valid api-key'] }
          }

        let(:'X-API-Key') { 'invalid-api-key' }

        run_test!
      end
    end
  end
end
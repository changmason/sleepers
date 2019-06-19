require 'swagger_helper'

describe 'Following friends API' do
  let!(:current_user) { create(:user) }
  let!(:following_user) { create(:user) }

  # POST /api/followings
  path '/api/followings' do
    post 'Follow a friend' do
      tags 'friends'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :'X-API-Key', in: :heade, type: :string, format: :uuid, required: true
      parameter name: :following, in: :body, schema: {
        type: :object,
        properties: {
          id: { type: :integer, required: true },
        }
      }

      response '200', 'Following friend record created' do
        schema type: :object,
          properties: {
            status: { type: :string, enum: ['success'] },
            type: { type: :string, enum: ['User'] },
            record: {
              type: :object,
              properties: {
                id: { type: :integer },
                email: { type: :string, format: 'email' }
              }
            }
          }

        let(:following) { { id: following_user.id } }
        let(:'X-API-Key') { current_user.api_key }

        run_test! do |res|
          json = JSON.parse(res.body)
          expect(json['status']).to eq('success')
          expect(json['type']).to eq('User')
          record = json['record']
          expect(record['id']).to eq(following_user.id)
          expect(record['email']).to eq(following_user.email)
        end
      end

      response '401', 'Unauthorized request' do
        schema type: :object,
          properties: {
            status: { type: :string, enum: ['error'] },
            message: { type: :string, enum: ['Unauthorized request, please provide a valid api-key'] }
          }

        let(:following) { { id: following_user.id } }
        let(:'X-API-Key') { 'invalid-api-key' }
        run_test!
      end

      response '400', 'Following user record not found' do
        schema type: :object,
          properties: {
            status: { type: :string, enum: ['error'] },
            message: { type: :string }
          }

        let(:following) { { id: 1_000_000 } }
        let(:'X-API-Key') { current_user.api_key }

        run_test! do |res|
          json = JSON.parse(res.body)
          expect(json['status']).to eq('error')
          expect(json['message']).to match('Couldn\'t find User')
        end
      end
    end
  end

end
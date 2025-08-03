# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Api::V1::Urls', integration: true do
  path '/api/v1/urls/encode' do
    post 'Creates a short URL' do
      tags 'URLs'
      consumes 'multipart/form-data'
      produces 'application/json'
      parameter name: :url, in: :formData, schema: {
        type: :object,
        properties: {
          'url[original_url]' => { type: :string }
        },
        required: [
          'url[original_url]'
        ]
      }
      response '201', 'URL created' do
        let(:url) { { original_url: 'https://example.com' } }
        run_test!
      end

      response '422', 'Invalid URL' do
        let(:url) { { original_url: 'invalid-url' } }
        run_test!
      end
    end
  end

  path '/api/v1/urls/decode' do
    get 'Decodes a short URL' do
      tags 'URLs'
      produces 'application/json'

      parameter name: :short_url, in: :query, type: :string, required: true,
                example: 'http://localhost:3000/abc12345'

      response '200', 'URL found' do
        let!(:url) { create(:url, original_url: 'https://example.com', short_url: 'http://localhost:3000/abc12345') }
        let(:short_url) { url.short_url }
        run_test!
      end

      response '404', 'URL not found' do
        let(:short_url) { 'http://localhost:3000/nonexistent' }
        run_test!
      end
    end
  end
end

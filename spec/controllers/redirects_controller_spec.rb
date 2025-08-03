# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RedirectsController, type: :controller do
  let(:original_url) { 'https://example.com' }
  let(:url) { create(:url, original_url:) }
  let(:uniq_key) { url.short_url.split('/').last }

  describe 'GET #show' do
    context 'when short URL exists' do
      it 'redirects to the original URL' do
        get :show, params: { uniq_key: }

        expect(response).to redirect_to(original_url)
        expect(response).to have_http_status(:redirect)
      end

      it 'allows redirect to external hosts' do
        get :show, params: { uniq_key: }

        expect(response.headers['Location']).to include(original_url)
      end
    end

    context 'when short URL does not exist' do
      it 'returns not found status' do
        get :show, params: { uniq_key: 'non-existent-key' }

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end

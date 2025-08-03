# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Url, type: :model do
  describe 'validations' do
    it 'validates presence of original_url' do
      url = build(:url, original_url: nil)
      expect(url).not_to be_valid
      expect(url.errors[:original_url]).to include("can't be blank")
    end

    it 'validates URL format' do
      url = build(:url, original_url: 'not-a-url')
      expect(url).not_to be_valid
    end

    it 'accepts valid HTTP URLs' do
      url = build(:url, original_url: 'http://example.com')
      expect(url).to be_valid
    end

    it 'accepts valid HTTPS URLs' do
      url = build(:url, original_url: 'https://example.com')
      expect(url).to be_valid
    end
  end

  describe 'callbacks' do
    it 'generates a short URL before validation' do
      url = build(:url, short_url: nil)
      url.valid?
      expect(url.short_url).to be_present
    end

    it 'generates unique short URLs' do
      url1 = create(:url)
      url2 = create(:url)
      expect(url1.short_url).not_to eq(url2.short_url)
    end
  end

  describe 'URL generation' do
    it 'generates URLs with correct format' do
      url = create(:url)
      domain_url = ENV.fetch('DOMAIN_URL')
      expect(url.short_url).to match(%r{\A#{Regexp.escape(domain_url)}/.+\z})
    end
  end
end

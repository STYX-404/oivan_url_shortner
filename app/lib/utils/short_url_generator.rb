# frozen_string_literal: true

module Utils
  module ShortUrlGenerator
    def self.generate
      loop do
        uniq_key = SecureRandom.urlsafe_base64(rand(2..10))
        short_url = "#{Rails.application.credentails[:domain_url]}/#{uniq_key}"
        return short_url unless Url.exists?(short_url:)
      end
    end
  end
end

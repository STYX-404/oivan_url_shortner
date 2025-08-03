# frozen_string_literal: true

class Url < ApplicationRecord
  validates :original_url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp }, length: { maximum: 255 }
  validates :short_url, presence: true, uniqueness: true
  before_validation :generate_short_url

  def generate_short_url
    self.short_url = ::Utils::ShortUrlGenerator.generate
  end
end

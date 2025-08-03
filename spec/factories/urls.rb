# frozen_string_literal: true

FactoryBot.define do
  factory :url do
    original_url { Faker::Internet.url }
    short_url { Faker::Internet.url }
  end
end

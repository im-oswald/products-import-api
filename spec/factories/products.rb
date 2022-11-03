# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    upc { Faker::Alphanumeric.alphanumeric(number: 10).insert(3, '-') }
    import_date { Faker::Time.between(from: DateTime.now - 3, to: DateTime.now - 1) }
    weight { Faker::Number.decimal(l_digits: 2) }
    unit { %w[kilograms pounds grams].sample }
    association :category
  end
end

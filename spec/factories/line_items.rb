FactoryBot.define do
  factory :line_item do
    traveler_name { Faker::Name.name }
    start_date { Faker::Date.forward(days: 1) }
    end_date { Faker::Date.forward(days: 7) }
    description { Faker::Lorem.sentence }
    category { LineItem.categories.keys.sample }
    quantity { Faker::Number.between(from: 1, to: 10) }
    unit_price { Faker::Commerce.price(range: 10.0..100.0) }
  end
end

FactoryBot.define do
  factory :booking do
    booking_id { Faker::Number.unique.number(digits: 5).to_s }
    hotel_name { Faker::Company.name }
    traveler_name { Faker::Name.name }
    check_in { Faker::Date.forward(days: 1) }
    check_out { Faker::Date.forward(days: 7) }
    company_name { Faker::Company.name }
    street { Faker::Address.street_name }
    city { Faker::Address.city }
    zip { Faker::Address.zip_code }
    country { Faker::Address.country }
    street_number { Faker::Address.building_number }
  end
end

FactoryBot.define do
  factory :customer do
    order
    name { "knowledge" }
    email { "efe.love@gmail.com"}
    password 
    credit_card
    address_1
    address_2
    city
    region
    postal_code
    country
    day_phone
    eve_phone
    mob_phone
  end
end
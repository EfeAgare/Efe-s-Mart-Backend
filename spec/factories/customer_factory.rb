FactoryBot.define do
  factory :customer do
    customer_id  {1}
    email {"efe.love@gmail.com"}
    password {"123efe"}
    name {"knowledge"}
    credit_card{ ""}
    address_1{ ""}
    address_2 {""}
    city {""}
    region{ ""}
    postal_code{ ""}
    country{""}
    day_phone {""}
    shipping_region_id {1}
    eve_phone{""}
    mob_phone {""}
    # order
  end
end
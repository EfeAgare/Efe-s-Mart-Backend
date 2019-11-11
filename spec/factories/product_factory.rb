FactoryBot.define do
  factory :product do
    name
    description
    price
    discounted_price
    image
    image_2
    thumbnail
    display

    category
    attribute_value
  end
end
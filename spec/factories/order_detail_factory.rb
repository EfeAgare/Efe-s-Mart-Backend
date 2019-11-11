FactoryBot.define do 
  factory :order_detail do
    order_id
    product_id
    attributes
    product_name
    quantity
    unit_cost
  end
end
FactoryBot.define do 
  factory :order do 
    total_amount
    created_on
    shipped_on
    status
    comments
    customer
    auth_code
    reference
    shipping
    tax
  end
end
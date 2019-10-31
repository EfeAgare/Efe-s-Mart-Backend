class Review < ApplicationRecord
  self.table_name = 'review'

  validates :review, presence: true, length: { minimum: 5 }
  validates :product_id, presence: true
  validates :customer_id, presence: true
  
  
end

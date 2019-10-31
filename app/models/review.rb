class Review < ApplicationRecord
  self.table_name = 'review'

  validates :review, presence: true, length: { minimum: 5 }
  validates :product_id, presence: true
  validates :customer_id, presence: true
  
  
  validates :rating, inclusion: { in:  [0, 1, 2, 3, 4, 5], message: "invalid rating" }
end

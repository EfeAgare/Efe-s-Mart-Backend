class Customer < ApplicationRecord
  self.table_name = 'customer'
  has_secure_password

  before_save   :downcase_email
  VALID_EMAIL =/\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.freeze

  VALID_PASSWORD = /\A(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}/
  validates :name, presence: true, length: { maximum: 100 }, format: { with: /[a-zA-Z]/}
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL }, uniqueness: { case_sensitive: false }

  validates :password, presence: true, length: { minimum: 6 }, format: { with: VALID_PASSWORD }



  private

  def downcase_email
    self.email = email.downcase
  end
end

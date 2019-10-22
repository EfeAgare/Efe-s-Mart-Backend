
class CreditCardModel
  attr_accessor :credit_card
  include ActiveModel::Validations
  validates :credit_card, credit_card_number: true
  def initialize(params={})
    @credit_card = params[:credit_card]
    ActionController::Parameters.new(params).permit(:credit_card)
  end
end



module Validate
  class UpdateCustomerProfile
    include ActiveModel::Validations

    attr_accessor :address_1, :address_2, :city, :region, :postal_code, :country, :shipping_region_id



    validates :address_1, presence: true, length: { maximum: 100 }
    validates :address_2, presence: true, length: { maximum: 255 }

    validates :city, presence: true
    validates :region, presence: true

    validates :postal_code, presence: true, numericality: true
    validates :country, presence: true
    validates :shipping_region_id, presence: true, numericality: true
  
    def initialize(params={})
      @address_1 = params[:address_1]
      @address_2 = params[:address_2]
      @city = params[:city]
      @region = params[:region]
      @postal_code = params[:postal_code]
      @country = params[:country]
      @shipping_region_id = params[:shipping_region_id]
      ActionController::Parameters.new(params).permit(:address_1,:address_2, :city, :region, :postal_code, :country, :shipping_region_id)
    end

  end
end
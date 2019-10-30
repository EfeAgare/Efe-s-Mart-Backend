# The controller defined below is the shippiing controller,
#
#  Some methods are stubbed out for you to implement them from scratch
# while others may contain one or two bugs
#
# NB: Check the BACKEND CHALLENGE TEMPLATE DOCUMENTATION linked in the readme of this repository
# to see our recommended endpoints, request body/param, and response object for each of these method

class ShippingController < ApplicationController
  # get all shipping regions
  def get_shipping_regions
    shipping_regions = ShippingRegion.all()
    json_response(shipping_regions)
  end

  # get all shipping type for a shipping region
  def get_shipping_type
    shipping_regions_type = Shipping.where("shipping_region_id = ?", params[:shipping_region_id])

    if !shipping_regions_type.blank?
      json_response(shipping_regions_type)
    else
      json_response({message: "shipping type for a shipping region #{params[:shipping_region_id]} not found"}, 404)
    end
  end
end

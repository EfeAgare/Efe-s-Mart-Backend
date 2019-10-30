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
    json_response({ message: 'NOT IMPLEMENTED' })
  end
end

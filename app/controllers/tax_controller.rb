# The controller defined below is the tax controller,
#
#  Some methods are stubbed out for you to implement them from scratch
# while others may contain one or two bugs
#
# NB: Check the BACKEND CHALLENGE TEMPLATE DOCUMENTATION linked in the readme of this repository
# to see our recommended endpoints, request body/param, and response object for each of these method

class TaxController < ApplicationController
  # get all tax types
  def get_all_tax
    all_tax = Tax.all()
    json_response(all_tax)
  end
  # get a single tax type using tax id
  def get_single_tax
    if params[:tax_id].to_i > 0
      single_tax = Tax.where("tax_id = ?", params[:tax_id])
      if single_tax
        json_response(single_tax)
      else
        json_response({ message: "#{params[:tax_id]} not found" }, 404)
      end
    else
      json_response({ message: "#{params[:tax_id]} is invalid" }, 422)
    end
  end
end

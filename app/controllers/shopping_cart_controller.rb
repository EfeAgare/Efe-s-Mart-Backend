# The controller defined below is the shopping cart controller,
#
#  Some methods are stubbed out for you to implement them from scratch
# while others may contain one or two bugs
#
# NB: Check the BACKEND CHALLENGE TEMPLATE DOCUMENTATION linked in the readme of this repository
# to see our recommended endpoints, request body/param, and response object for each of these method

class ShoppingCartController < ApplicationController
  before_action :set_cart
  # generate random unique id for cart identifier
  def generate_unique_cart
    json_response({cart_id: session[:cart_id]})
  end

  # add item to existing cart with cart id
  def add_item_to_cart
    
    if params[:cart_id] == session[:cart_id]

      add_to_cart =  StoredProcedureService.new.execute("shopping_cart_add_product", "'#{session[:cart_id]}','#{params[:product_id]}', '#{params[:attribute_value]}'")
  
      json_response(add_to_cart)
    else
      json_response({message: "server error"}, 500)
    end
  end

  # get all items in a shopping cart using cart id
  def get_cart
    json_response({ message: 'NOT IMPLEMENTED' })
  end

  # update quantity of an item in a shopping cart
  def update_cart_item
    json_response({ message: 'NOT IMPLEMENTED' })
  end

  # remove all items from a shopping cart
  def empty_cart
    json_response({ message: 'NOT IMPLEMENTED' })
  end

  # remove a specific item from a shopping cart
  def remove_item_from_cart
    json_response({ message: 'NOT IMPLEMENTED' })
  end

  # create order for all items in a shopping cart
  def create_order
    json_response({ message: 'NOT IMPLEMENTED' })
  end

  # get all orders placed by a customer
  def get_customer_orders
    json_response({ message: 'NOT IMPLEMENTED' })
  end

  # get details of items in an order
  def get_order_summary
    json_response({ message: 'NOT IMPLEMENTED' })
  end

  # checkout order and process stripe payment
  def process_stripe_payment
    json_response({ message: 'NOT IMPLEMENTED' })
  end


  private 

  def set_cart
    @cart = ShoppingCart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    session[:cart_id] = @current_user.customer_id.to_s
  end
end

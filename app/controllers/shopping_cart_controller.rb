# The controller defined below is the shopping cart controller,
#
#  Some methods are stubbed out for you to implement them from scratch
# while others may contain one or two bugs
#
# NB: Check the BACKEND CHALLENGE TEMPLATE DOCUMENTATION linked in the readme of this repository
# to see our recommended endpoints, request body/param, and response object for each of these method
require 'stripe'

class ShoppingCartController < ApplicationController
  before_action :set_cart
  # generate random unique id for cart identifier
  def generate_unique_cart
    json_response({cart_id: session[:cart_id]})
  end

  # add item to existing cart with cart id
  def add_item_to_cart
    
    if params[:cart_id] == session[:cart_id] && params[:cart_id].to_i == @current_user.customer_id

      add_to_cart =  StoredProcedureService.new.execute("shopping_cart_add_product", "'#{session[:cart_id]}','#{params[:product_id]}', '#{params[:attribute_value]}'")
  
      json_response(add_to_cart)
    else
      json_response({message: "server error"}, 500)
    end
  end

  # get all items in a shopping cart using cart id
  def get_cart
    if params[:cart_id] == session[:cart_id] && params[:cart_id].to_i == @current_user.customer_id
      get_items_in_cart =  StoredProcedureService.new.execute("shopping_cart_get_products", "'#{session[:cart_id]}'")

      json_response(get_items_in_cart)
    else
      json_response({message: "cart does not exit"}, 404)
    end
  end

  # update quantity of an item in a shopping cart
  def update_cart_item
    if params[:quantity].is_a? Integer
      update_cart = ShoppingCart.where("cart_id = ? AND item_id = ? ", session[:cart_id], params[:item_id])
      if update_cart
        update_cart.update(quantity: params[:quantity])
        json_response(update_cart)

      else
        json_response({ message: "cart with #{params[:item_id]} does not exit" }, 404)
      end

    else
      json_response({ message: 'quantity must be an integer' }, 422)
    end
      
  end

  # remove all items from a shopping cart
  def empty_cart
    if params[:cart_id] == session[:cart_id] && params[:cart_id] == @current_user.customer_id.to_s
      destroy_cart = ShoppingCart.where("cart_id = ?", params[:cart_id])
      if destroy_cart
        destroy_cart.destroy_all
        session[:cart_id] = nil
        json_response([])
      else
        json_response({ message: "cart not found" }, 404)
      end
    else
      json_response({ message: "Not Authorize" }, 409)
    end
  end

  # remove a specific item from a shopping cart
  def remove_item_from_cart
    cart = ShoppingCart.find(params[:item_id])
    if cart
      cart.destroy(params[:item_id])
      json_response({ message: "#{params[:item_id]} remove successfully" })
    else
      json_response({ message: "#{params[:item_id]} not found" }, 404)
    end
  end

  # create order for all items in a shopping cart
  def create_order
    if params[:cart_id] == session[:cart_id].to_i && params[:cart_id] == @current_user.customer_id
      create_order =  StoredProcedureService.new.execute("shopping_cart_create_order", "'#{params[:cart_id]}', '#{@current_user.customer_id}','#{params[:shipping_id]}', '#{params[:tax_id]}'")
      json_response(create_order)
    else
      json_response({message: "cart does not exit"}, 404)
    end
  end

  # get all orders placed by a customer
  def get_customer_orders
      customer_orders =  StoredProcedureService.new.execute("orders_get_by_customer_id", "'#{@current_user.customer_id}'")
      if  customer_orders
        json_response(customer_orders)
      else
        json_response({message: "Orders does not exit"}, 404)
      end
  end


  # get details of items in an order
  def get_order_summary
    customer_orders_summary =  StoredProcedureService.new.execute("orders_get_order_details", "'#{params[:order_id]}'")
    if  customer_orders_summary
      json_response(customer_orders_summary)
    else
      json_response({message: "Orders does not exit"}, 404)
    end
  end

  # get details of items in an order
  def get_short_order_summary
    customer_orders_summary =  StoredProcedureService.new.execute("orders_get_order_short_details", "'#{params[:order_id]}'")
    if  customer_orders_summary
      json_response(customer_orders_summary)
    else
      json_response({message: "Orders does not exit"}, 404)
    end
  end

  # checkout order and process stripe payment
  def process_stripe_payment
   
    begin 
        if (params[:order_id].blank?)
          return json_response({message: "params cannot be empty"}, 400)
        else
          @customer_order_summary =  StoredProcedureService.new.execute("orders_get_order_short_details", "'#{params[:order_id]}'")

          if (@customer_order_summary[0].status == 1)
            return json_response({
              message: 'Payment has been made for this order',
            }, 409)
          else
            stripe_payment
          end
        end
    rescue Stripe::CardError => e
      json_response({ message: e.message,  status: e.http_status, TYPE: e.error.type, ChargeID: e.error.charge })
    end
  end


  private 

  def set_cart
    @cart = ShoppingCart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    session[:cart_id] = @current_user.customer_id.to_s
  end

  def stripe_payment
      customer = Stripe::Customer.create({
        email: @current_user.email,
        source: params[:stripeToken],
      })
    
      ## Creates the actual charges by calling our API.
      @charge = Stripe::Charge.create({
        customer: customer.id,
        amount: @customer_order_summary.map(&:total_amount).reduce(:+).to_i * 100,
        description: "Charge for #{params[:email]}",
        currency: 'usd',
      })
    if (@charge.paid)
      @customer_orders = StoredProcedureService.new.execute("orders_update_status", "'#{params[:order_id]}', '#{1}'")
      json_response(@charge, 201)
      
    end
  end

end

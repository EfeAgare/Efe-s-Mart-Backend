# The controller defined below is the customer controller,
#
#  Some methods are stubbed out for you to implement them from scratch
# while others may contain one or two bugs
#
# NB: Check the BACKEND CHALLENGE TEMPLATE DOCUMENTATION linked in the readme of this repository
# to see our recommended endpoints, request body/param, and response object for each of these method

class CustomerController < ApplicationController
  before_action :check_if_exist, only: [:create, :login]
  skip_before_action :authorize_request, only: [:create, :login]
  # create a new customer account
  def create
  
    if @foundCustomer
       json_response({ error: Message.account_exists }, 409) 
    else
      user = Customer.create!(auth_params)
      auth_token = AuthenticateUser.new(user.name, user.email, user.password).call

      response = {
        message: Message.account_created,
        auth_token: auth_token
      }
      json_response(response, :created)
    end
    
  rescue ExceptionHandler::ServerError => e
    json_response({ error: e.message }, 500) 
  end

  # login a customer account
  def login

    if !@foundCustomer
      json_response({ error: Message.invalid_credentials }, 404) 
    else

     auth_token = AuthenticateUser.new(nil, auth_params[:email], auth_params[:password]).call

     response = {
       message: Message.login_success,
       auth_token: auth_token
     }
     json_response(response, :created)
    end

  rescue ExceptionHandler::ServerError => e
    json_response({ error: e.message }, 500) 
  end

  # get the logged in customer profile
  def get_customer_profile

     @current_user["password_digest"] = ''
     response = {
       auth_token: @current_user
     }
     json_response(response, :created)
  
  rescue ExceptionHandler::ServerError => e
    json_response({ error: e.message }, 500) 
  end

  # update a customer profile such as
  # name, email, password, day_phone, eve_phone and mob_phone
  def update_customer_profile
    # "name": "knowledge",
    # "email": "knoledgeagayu145@gmail.com",
    # "password_digest": "",

    # "day_phone": null,
    # "eve_phone": null,
    # "mob_phone": null
    json_response({ message: 'NOT IMPLEMENTED' })
  end

  # update a customer billing info such as
  # address_1, address_2, city, region, postal_code, country and shipping_region_id
  def update_customer_address

    # "address_1": null,
    # "address_2": null,
    # "city": null,
    # "region": null,
    # "postal_code": null,
    # "country": null,
    # "shipping_region_id": 1,
    json_response({ message: 'NOT IMPLEMENTED' })
  end

  # update a customer credit card
  def update_credit_card
    json_response({ message: 'NOT IMPLEMENTED' })
  end

  def auth_params
    params.permit(:name, :email, :password)
  end

  private

  def check_if_exist
    @foundCustomer = Customer.find_by(email: auth_params[:email]);
  end

end

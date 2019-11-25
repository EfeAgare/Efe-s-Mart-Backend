# The controller defined below is the customer controller,
#
#  Some methods are stubbed out for you to implement them from scratch
# while others may contain one or two bugs
#
# NB: Check the BACKEND CHALLENGE TEMPLATE DOCUMENTATION linked in the readme of this repository
# to see our recommended endpoints, request body/param, and response object for each of these method

require 'validations/index'
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
    json_response({ error: e.message }, :internal_server_error) 
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
     json_response(response, :ok)
    end

  rescue ExceptionHandler::ServerError => e
    json_response({ error: e.message }, 500) 
  end

  # get the logged in customer profile
  def get_customer_profile

     response = {
       auth_token: @current_user
     }
     
     json_response(response, :ok)
  
  rescue ExceptionHandler::ServerError => e
    json_response({ error: e.message }, :internal_server_error) 
  end

  # update a customer profile such as
  # name, email, password, day_phone, eve_phone and mob_phone
  def update_customer_profile
    
    if @current_user
      update_params = {
         name: params[:name] || @current_user.name,
         email: params[:email] || @current_user.email,
         password: params[:password] || @current_user.password_digest,
         day_phone: params[:day_phone].to_i || @current_user.day_phone,
         eve_phone: params[:eve_phone].to_i || @current_user.eve_phone,
         mob_phone: params[:mob_phone].to_i || @current_user.mob_phone
      }
          
        @current_user.update!(update_params)
        @current_user[:password_digest] = ''
 
        json_response(@current_user, :ok)

    else
      raise(ExceptionHandler::BadRequest, ("#{Message.not_found}"))
    end
   
  rescue ExceptionHandler::ServerError => e
    json_response({ error: e.message }, :internal_server_error)  
  end

  # update a customer billing info such as
  # address_1, address_2, city, region, postal_code, country and shipping_region_id
  def update_customer_address

    if @current_user
      update_params = {
        address_1: params[:address_1],
        address_2: params[:address_2],
        city: params[:city],
        region: params[:region],
        postal_code: params[:postal_code],
        country: params[:country],
        shipping_region_id: params[:shipping_region_id]
      }

      # validation params
      param = Validate::UpdateCustomerProfile.new(update_params)

      if !param.valid?
        json_response(param.errors, :bad_request)
      else  
          update_customer_details = StoredProcedureService.new.execute("customer_update_address", "#{@current_user.customer_id},'#{param.address_1}', '#{param.address_2}', '#{param.city}', '#{param.region}', '#{param.postal_code}', '#{param.country}', #{param.shipping_region_id}")
        
        json_response(update_customer_details[0].to_h, :ok)
      end

    else
      raise(ExceptionHandler::BadRequest, ("#{Message.not_found}"))
    end
   
  rescue ExceptionHandler::ServerError => e
    json_response({ error: e.message }, :internal_server_error) 
  end

  # update a customer credit card
  def update_credit_card
    
    if @current_user
      update_params = {
        credit_card: params[:credit_card].to_i
      }
  
      # validation params
      param = CreditCardModel.new(update_params)

      if !param.valid?
        json_response(param.errors, :bad_request)
      else  
        update_customer_credit_card = StoredProcedureService.new.execute("customer_update_credit_card", "#{@current_user.customer_id},'#{param.credit_card}'")

        json_response(update_customer_credit_card[0].to_h, :ok)
      end

    else
      raise(ExceptionHandler::BadRequest, ("#{Message.not_found}"))
    end
   
  rescue ExceptionHandler::ServerError => e
    json_response({ error: e.message }, :internal_server_error) 
  end

 

  private

  def auth_params
    params.permit(:name, :email, :password)
  end

  def check_if_exist
    @foundCustomer = Customer.find_by(email: auth_params[:email]);
  end

end

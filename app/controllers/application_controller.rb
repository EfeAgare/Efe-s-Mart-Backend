class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler
  include ActiveSupport::NumberHelper

  before_action :authorize_request

  def welcome
    json_response({ message: "Welcome to  Efe's Mart shop api" })
  end

  private

  def authorize_request
    @current_user = (AuthorizeApiRequest.new(request.headers).call)[:user]
    if @current_user
      return @current_user
    else
      return json_response({ message: 'You need to login/register' })
    end
  end
end

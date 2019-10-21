# frozen_string_literal: true

module ExceptionHandler
  extend ActiveSupport::Concern

  class InvalidToken < StandardError; end
  class MissingToken < StandardError; end

  class UnAuthorized < StandardError; end
  class InvalidCredentials < StandardError; end

  class AuthenticationError < StandardError; end
  class ServerError < StandardError; end

  class BadRequest < StandardError; end
  class EmptyResource < StandardError; end

  included do

    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: { data: nil, errors: [{ message: e.message }] }, status: :not_found
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      render json: { data: nil, errors: [{ message: "Invalid input: #{e.record.errors.full_messages.join(', ')}" }] }, status: :unprocessable_entity
    end

    rescue_from ExceptionHandler::BadRequest do |e|
      render json: { data: nil, errors: [{ message: e.message }] }, status: 400
    end
 

    rescue_from ExceptionHandler::InvalidToken, ExceptionHandler::InvalidCredentials do |e|
      render json: { data: nil, errors: [{ message: e.message }] }, status: 401
    end

    rescue_from ExceptionHandler::UnAuthorized do |e|
      render json: { data: nil, errors: [{ message: e.message }] }, status: 403
    end

    rescue_from ActiveRecord::RecordNotUnique do |e|
      render json: { data: nil, errors: [{ message: e.message }] }, status: 409
    end

    rescue_from ExceptionHandler::EmptyResource do |e|
      render json: { data: nil, errors: [{ message: e.message }] }, status: 200
    end

    rescue_from ExceptionHandler::ServerError do |e|
      render json: { data: nil, errors: [{ message: e.message }] }, status: 500
    end
  end
end

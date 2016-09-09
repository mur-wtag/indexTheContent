module ApiExceptionHandling
  extend ActiveSupport::Concern

  included do
    rescue_from Grape::Exceptions::ValidationErrors do |e|
      # input:
      # {
      #   ["account_id"]=>[#<Grape::Exceptions::Validation: is invalid>],
      #   ["duration"]=>[#<Grape::Exceptions::Validation: is invalid>]
      # }

      errors = {}
      e.errors.each do |keys, values|
        keys.each do |key|
          errors[key] ||= []
          errors[key].concat values.map(&:to_s)
        end
      end

      response = { status: 422, message: e.message, errors: errors }
      rack_response response.to_json, 422
    end

    rescue_from ActiveRecord::RecordInvalid do |error|
      Rails.logger.error error.message
      Rails.logger.error error.backtrace.join("\n")
      Rack::Response.new(
        {
          'status'  => 422,
          'message' => error.record.errors.full_messages.to_sentence,
          'errors'  => error.record.errors
        }.to_json, 422)
    end

    rescue_from ActiveRecord::RecordNotFound do |error|
      Rails.logger.error error.message
      Rails.logger.error error.backtrace.join("\n")
      Rack::Response.new(
        {
          'status' => 404
        }.to_json, 404)
    end

    rescue_from Exception do |error|
      Rails.logger.error error.message
      Rails.logger.error error.backtrace.join("\n")
      response = {
        status: 500,
      }

      if Rails.env.development? || Rails.env.test?
        response.merge!(
          message: error.message,
          errors: error.class.to_s,
          trace: error.backtrace,
        )
      end

      Rack::Response.new(response.to_json, 500, 'Content-Type' => 'application/json')
    end
  end
end

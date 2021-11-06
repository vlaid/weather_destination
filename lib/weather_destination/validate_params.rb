# frozen_string_literal: true

require 'json-schema'

module WeatherDestination
  class ValidateParams
    include Singleton

    def query_data(params)
      validate_schema(params)
      query_params(params)
    rescue StandardError => e
      e.message
      raise
    end

    private

    # transform params to api documentation
    # https://www.weatherapi.com/docs/
    def query_params(params)
      {
        q: params[:city]
      }.to_query
    end

    def validate_schema(params)
      schema = {
        'type' => 'object',
        'required' => ['city'],
        'properties' => {
          'city' => { 'type' => 'string' }
        }
      }
      JSON::Validator.validate!(schema, params)
    end
  end
end

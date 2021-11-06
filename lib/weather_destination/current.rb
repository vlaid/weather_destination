# frozen_string_literal: true

require 'weather_destination/validate_params'

module WeatherDestination
  class Current < WeatherDestination::ValidateParams

    private

    # transform params to api documentation
    # https://www.weatherapi.com/docs/
    def query_params(params)
      {
        q: params[:city],
        api: params[:api] || 'no'
      }.to_query
    end

    def validate_schema(params)
      schema = {
        'type' => 'object',
        'required' => ['city'],
        'properties' => {
          'city' => { 'type' => 'string' },
          'api' => { 'type' => 'string', 'default' => 'no' }
        }
      }
      JSON::Validator.validate!(schema, params)
    end
  end
end

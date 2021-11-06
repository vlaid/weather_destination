# frozen_string_literal: true

require 'weather_destination/validate_params'

module WeatherDestination
  class History < WeatherDestination::ValidateParams

    private

    # transform params to api documentation
    # https://www.weatherapi.com/docs/
    def query_params(params)
      {
        q: params[:city],
        dt: params[:date]
      }.to_query
    end

    def validate_schema(params)
      schema = {
        'type' => 'object',
        'required' => ['city', 'date'],
        'properties' => {
          'city' => { 'type' => 'string' },
          'date' => { 'type' => 'date' }
        }
      }
      JSON::Validator.validate!(schema, params)
    end
  end
end

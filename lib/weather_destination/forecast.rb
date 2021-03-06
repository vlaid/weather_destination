# frozen_string_literal: true

require 'weather_destination/validate_params'

module WeatherDestination
  class Forecast < WeatherDestination::ValidateParams

    private

    # transform params to api documentation
    # https://www.weatherapi.com/docs/
    def query_params(params)
      {
        q: params[:city],
        days: params[:days].to_i || 1,
        api: params[:api] || 'no',
        alerts: params[:alerts] || 'no'
      }.to_query
    end

    def validate_schema(params)
      schema = {
        'type' => 'object',
        'required' => ['city'],
        'properties' => {
          'city' => { 'type' => 'string' },
          'days' => { 'type' => 'integer',
                      'default' => 1,
                      'maximum' => 10 },
          'api' => { 'type' => 'string', 'default' => 'no' },
          'alerts' => { 'type' => 'string', 'default' => 'no' }
        }
      }
      JSON::Validator.validate!(schema, params)
    end
  end
end

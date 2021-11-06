# frozen_string_literal: true

require 'weather_destination/version'
require 'uri'
require 'net/http'
require 'openssl'

module WeatherDestination
  class << self
    attr_accessor :api_token

    BASE_URL = 'https://api.weatherapi.com/v1/'

    def config
      yield self
    end

    def call(method_name, params)
      @params = params
      get_data(method_name)
    rescue StandardError => e
      p e.message
    end

    private

    def get_data(method_name)
      query_data = WeatherDestination.const_get(method_name.classify).instance.query_data(@params)
      return_data(method_name, query_data)
    rescue StandardError => e
      p "We are sorry but #{method_name} resource is a wrong resource. Please check api documentation."
    end

    def get_response(url)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(url)
      response = http.request(request)
      JSON.parse(response.read_body).with_indifferent_access
    end

    def return_data(method, query_data)
      url = URI("#{BASE_URL}#{method}.json?key=#{api_token}&#{query_data}")
      body = get_response(url)
      body[:current][:feelslike_c]
    end
  end
end

%w[
  /weather_destination/*.rb
].each do |folder|
  Dir[File.dirname(__FILE__) + folder].sort.each { |file| require file }
end

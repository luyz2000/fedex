require "erb"
require "json"
require "httparty"
require "fedex/helpers"

module Fedex
  class Rates
    include Helpers
    attr_accessor :credentials, :quote_params, :parsed_response, :rates

    URL_PRODUCTION = "https://wsbeta.fedex.com:443/xml".freeze
    URL_DEVELOPMENT = "https://wsbeta.fedex.com:443/xml".freeze

    def initialize(credentials = {}, quote_params = {})
      @credentials = credentials
      @quote_params = quote_params
    end

    def call
      response = HTTParty.post(
        request_url,
        body: to_xml,
        headers: { "Content-Type" => "text/xml" },
        verify: false
      )
      return [] unless response.ok?

      build_response(response)
    rescue StandardError => e
      raise RatesError, e.message
    end

    def self.get(credentials, quote_params)
      new(credentials, quote_params).call
    end

    private

    def request_url
      @credentials[:enviroment] == "production" ? URL_PRODUCTION : URL_DEVELOPMENT
    end

    def to_xml
      @to_xml ||= ERB.new(File.new(xml_template_path).read, 0, ">").result(binding)
    end

    def xml_template_path
      @xml_template_path ||= File.join(Fedex.root, "lib/fedex/xml_templates/rates_request.xml.erb")
    end

    def build_response(response)
      begin
        @parsed_response = response.parsed_response
      rescue StandardError
        response.body
      end
      
      rates_details = @parsed_response["RateReply"]["RateReplyDetails"]
      return [] if rates_details.nil?

      @rates = @parsed_response["RateReply"]["RateReplyDetails"].map do |sigle_result|
        token = sigle_result["ServiceType"]
        next if token.nil?

        rate = filter_rate(sigle_result)
        next if rate.nil?

        price = rate["ShipmentRateDetail"]["TotalNetChargeWithDutiesAndTaxes"]["Amount"]
        build_rate(price, token)
      end
      @rates.compact!
      @rates.sort_by { |rate| rate[:price] }
    end

    def filter_rate(sigle_result)
      sigle_result["RatedShipmentDetails"].find do |detail|
        base_exchange = detail["ShipmentRateDetail"]["CurrencyExchangeRate"]
        base_exchange["FromCurrency"] == "MXN" && base_exchange["IntoCurrency"] == "MXN"
      end
    end

    def build_rate(price, token)
      {
        "price": price.to_f,
        "currency": "MXN",
        "service_level": {
          "name": titleize(token),
          "token": token
        }
      }
    end
  end
end

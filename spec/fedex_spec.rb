# frozen_string_literal: true

RSpec.describe Fedex do
  let(:credentials) do
    {
      key: "",
      password: ""
    }
  end

  let(:quote_params) do
    {
      address_from: {
        zip: "64000",
        country: "MX"
      },
      address_to: {
        zip: "64000",
        country: "MX"
      },
      parcel: {
        length: 25.0,
        width: 28.0,
        height: 46.0,
        distance_unit: "cm",
        weight: 6.5,
        mass_unit: "kg"
      }
    }
  end

  it "has a version number" do
    expect(Fedex::VERSION).not_to be nil
  end

  describe "rates" do
    it "get not empty result" do
      result = Fedex::Rates.get(credentials, quote_params)
      expect(result.size).not_to be 0
    end

    it "get empty result" do
      quote_params[:address_from][:zip] = "00000"
      result = Fedex::Rates.get(credentials, quote_params)
      expect(result.size).to be 0
    end
  end
end

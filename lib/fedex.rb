# frozen_string_literal: true
require 'pry'
require 'pry-byebug'
require_relative "fedex/version"
require 'fedex/rates'
module Fedex
  def self.root
    Pathname.new(File.expand_path("..", __dir__))
  end

  class Error < StandardError; end
  #Exceptions: Fedex::RateError
  class RatesError < StandardError; end
end

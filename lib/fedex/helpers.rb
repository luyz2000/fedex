module Fedex
  module Helpers

    def titleize(string)
      cleaned_string = string.gsub('_', ' ')
      cleaned_string.split(" ").map(&:capitalize).join(" ")
    end
    
  end
end

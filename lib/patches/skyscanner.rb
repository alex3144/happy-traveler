# Monkey Patch
# We're adding pricing method to Skyscanner Connection
module Skyscanner
  class Connection
    def self.pricing(*args)
      new.pricing(*args)
    end

    def pricing(params = {})
      segments = {
        :country => true,
        :currency => true,
        :locale => true,
        :originPlace => true,
        :destinationPlace => true,
        :outboundPartialDate => true,
        :inboundPartialDate => false
      }
      request('pricing', segments, params)
    end
  end
end

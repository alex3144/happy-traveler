class FlightsController < ApplicationController

  def home

  end

  def index
    Skyscanner::Connection.apikey = "prtl6749387986743898559646983194"
    results = Skyscanner::Connection.browse_grid( :country => "GB", :currency => "GBP", :locale => "en-GB", :originPlace => "LON", :destinationPlace => "JFK", :outboundPartialDate => "2016-12", :inboundPartialDate => "2016-12" )
    @results = results

  end
end

# :country => 'GB',
#         :currency => 'GBP',
#         :locale => "en-GB",
#         :originPlace => "UK",
#         :destinationPlace => "anywhere",
#         :outboundPartialDate => "anytime",
# :inboundPartialDate => false



result1['OriginLocation'] => LAX
result1['DestinationLocation'] => JFK

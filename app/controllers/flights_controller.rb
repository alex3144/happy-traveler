class FlightsController < ApplicationController

  def home

  end

  def index
    Skyscanner::Connection.apikey = "prtl6749387986743898559646983194"
    results = Skyscanner::Connection.browse_routes( :country => "GB", :currency => "GBP", :locale => "en-GB", :originPlace => "UK", :destinationPlace => "anywhere", :outboundPartialDate => "anytime", :inboundPartialDate => "anytime" )

    raise
    # @flight = Flight.new()
  end

end

class FlightsController < ApplicationController

  def home

  end

  def index
    # Skyscanner::Connection.apikey = "prtl6749387986743898559646983194"
    # results = Skyscanner::Connection.browse_routes( :country => "GB", :currency => "GBP", :locale => "en-GB", :originPlace => "UK", :destinationPlace => "anywhere", :outboundPartialDate => "anytime", :inboundPartialDate => "anytime" )

    # @flight = Flight.new()
    @trips = generate_sample_trips
  end




private

  def generate_sample_trips
    trips = []
    10.times do
      start_flight = Flight.new(
        start_place:["CDG","DPS","JFK","AMS","LGE"].sample,
        end_place:["CDG","DPS","JFK","AMS","LGE"].sample,
        start_date: DateTime.now + rand(1..10).days,
        end_date:DateTime.now + rand(11..15).days,
        company: ["Air France","Luftansa", "Vueling"].sample,
        flight_duration: [ "6H30" , "1H30", "12H40","7H00" ].sample
      )

      return_flight = Flight.new(
        start_place:["CDG","DPS","JFK","AMS","LGE"].sample,
        end_place:["CDG","DPS","JFK","AMS","LGE"].sample,
        start_date: DateTime.now + rand(16..20).days,
        end_date:DateTime.now + rand(21..30).days,
        company: ["Air France","Luftansa", "Vueling"].sample,
        flight_duration: [ "6H30" , "1H30", "12H40","7H00" ].sample
      )

      trip_price = [350, 600, 700, 1300].sample
      currency = ["$","¥","€"].sample
      global_start_trip_duration = rand(3..50)
      global_return_trip_duration = rand(3..50)

      trip = {
        start_flight: start_flight,
        return_flight: return_flight,
        trip_price: trip_price,
        currency: currency,
        global_start_trip_duration: global_start_trip_duration,
        global_return_trip_duration: global_return_trip_duration
      }
      trips << trip
    end
    return trips
  end
end

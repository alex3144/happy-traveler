require 'date'    # If not already required. If in Rails then you don't need this line).

class FlightsController < ApplicationController

  token = SacsRuby.client.fetch_token
  token.access_token
  token.expires_on

  def home
  end

  def index
    # User Params
    @periode = ["Choisissez votre période","Janvier","Février","Mars","Avril","Mai","Juin","Juillet","Août","Septembre","Octobre","Novembre","Décembre"]
    @passagers_number = ["0","1","2","3","4","5"]

    start_period = "2017-#{date_params("Janvier")}-01"
    lengthofstay = "5"

    search_params = {
      origin: "JFK",
      destination: "CDG",
      lengthofstay: "5",
      end_period: "2017-01-16".to_date,
      departuredate: start_period,
      returndate: (start_period.to_date + lengthofstay.to_i).to_s
    }

    @trips_results = ::GetFlightsService.new(search_params).call
    @trips_results
    # @flight = Flight.new()
    # @trips = generate_sample_trips
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

  def sort_by_duration(results)
  end

  def date_params(month)
    month_hash = {
      "Janvier" => "01",
      "Fevrier" => "02",
      "Mars" => "03",
      "Avril" => "04",
      "Mai" => "05",
      "Juin" => "06",
      "Juillet" => "07",
      "Aout" => "08",
      "Septembre" => "09",
      "Octobre" => "10",
      "Novembre" => "11",
      "Decembre" => "12",

    }

    month_hash[month]
  end
end




require 'date'    # If not already required. If in Rails then you don't need this line).

class FlightsController < ApplicationController

  token = SacsRuby.client.fetch_token
  token.access_token
  token.expires_on

  def home
  end

  def index
    # User Params
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
  end

  private

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




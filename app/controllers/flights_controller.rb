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
      end_period: "2017-01-28".to_date,
      departuredate: start_period,
      returndate: (start_period.to_date + lengthofstay.to_i).to_s
    }

    raw_results = ::GetFlightsService.new(search_params).call

    # # API calls to retrieve Flights Information during the holidays period of User
    # # flight_search_result => Array with RAW datas returned by all the API calls
    # while returndate.to_date <= end_period
    #   flight_search_result << SacsRuby::API::InstaFlightsSearch.get(origin: origin, destination: destination, departuredate: departuredate, returndate: returndate, limit: '1')
    #   departuredate = (departuredate.to_date + 1).to_s
    #   returndate = (returndate.to_date + 1).to_s
    # end

    # raw_results = []

    # # Iteration to select only desired information sorted by flights
    # flight_search_result.each do | result |
    #   # depart_info = result["PricedItineraries"][0]["AirItinerary"]["OriginDestinationOptions"]["OriginDestinationOption"][0]
    #   depart_segments_info = result["PricedItineraries"][0]["AirItinerary"]["OriginDestinationOptions"]["OriginDestinationOption"][0]["FlightSegment"]
    #   depart_segment_number = depart_segments_info.size
    #   return_segments_info = result["PricedItineraries"][0]["AirItinerary"]["OriginDestinationOptions"]["OriginDestinationOption"][1]["FlightSegment"]
    #   # return_info = result["PricedItineraries"][0]["AirItinerary"]["OriginDestinationOptions"]["OriginDestinationOption"][1]
    #   return_segment_number = return_segments_info.size

    #   i = flight_search_result.index(result) + 1
    #   flights_info = {}
    #   flights_info[:flight_id] = i
    #   flights_info[:flight_values] = []

    #   depart_segment_results = []
    #   return_segment_results = []
    #   price_results = []

    #   depart_segments_info.each do | segment_result |
    #     flights_info[:flight_values] << { start_segment_departure_airport: segment_result["DepartureAirport"]["LocationCode"],
    #       start_segment_departure_datetime: segment_result["DepartureDateTime"],
    #       start_segment_departure_timezone: segment_result["DepartureTimeZone"],
    #       start_segment_arrival_airport: segment_result["ArrivalAirport"]["LocationCode"],
    #       start_segment_arrival_datetime: segment_result["ArrivalDateTime"],
    #       start_segment_arrival_timezone: segment_result["ArrivalTimeZone"],
    #       start_segment_flight_number: segment_result["OperatingAirline"]["FlightNumber"],
    #       start_segment_marketing_airline: segment_result["OperatingAirline"]["Code"],
    #       stops: depart_segment_number - 1
    #     }
    #   end

    #   return_segments_info.each do | segment_result |
    #     flights_info[:flight_values] << { return_segment_departure_airport: segment_result["DepartureAirport"]["LocationCode"],
    #       return_segment_departure_datetime: segment_result["DepartureDateTime"],
    #       return_segment_departure_timezone: segment_result["DepartureTimeZone"],
    #       return_segment_arrival_airport: segment_result["ArrivalAirport"]["LocationCode"],
    #       return_segment_arrival_datetime: segment_result["ArrivalDateTime"],
    #       return_segment_arrival_timezone: segment_result["ArrivalTimeZone"],
    #       return_segment_flight_number: segment_result["OperatingAirline"]["FlightNumber"],
    #       return_segment_marketing_airline: segment_result["OperatingAirline"]["Code"],
    #       stops: return_segment_number - 1
    #     }
    #   end

    #   flights_info[:flight_values] << { price: result["PricedItineraries"][0]["AirItineraryPricingInfo"]["ItinTotalFare"]["TotalFare"]["Amount"],
    #     currency: result["PricedItineraries"][0]["AirItineraryPricingInfo"]["ItinTotalFare"]["TotalFare"]["CurrencyCode"]
    #   }
    #   raw_results << flights_info
    # end

    sorted_results = sort_by_price(raw_results)

    top5_results = top5(sorted_results)
    raise
  end

  private

  def sort_by_price(results)
    results.sort_by { |record| record[:flight_values].last[:price] }
  end

  def sort_by_duration(results)

  end

  def top5(results)
    results[0..4]
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




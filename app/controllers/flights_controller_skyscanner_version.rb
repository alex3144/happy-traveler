require 'date'    # If not already required. If in Rails then you don't need this line).
require 'skyscanner'
require 'patches/skyscanner'

class FlightsController < ApplicationController

  def index
    Skyscanner::Connection.url  = "partners.api.skyscanner.net/apiservices"
    Skyscanner::Connection.apikey = "prtl6749387986743898559646983194"
    Skyscanner::Connection.response_format = "ruby"


    api_results = []
    raw_results = []
    trips = []

    departure_date = ("2016-12-13").to_date
    return_date = ("2016-12-20").to_date
    end_period_date =  ("2017-01-13").to_date

    while return_date <= end_period_date
      departure_date_to_string = (departure_date).to_s
      return_date_to_string = (return_date).to_s
      api_results = Skyscanner::Connection.pricing({
        :country => "FR",
        :currency => "EUR",
        :locale => "fr-FR",
        :originPlace => "CDG-sky",
        :destinationPlace => "JFK-sky",
        :stops => 0,
        :duration => 1440,
        :pagesize => 1,
        :outboundPartialDate => departure_date,
        :inboundPartialDate => return_date
      })

      raw_results << api_results
      departure_date += 1
      return_date += 1
    end
    raw_results.each do |trip|
        depart_flight_id = trip["Itineraries"][0]["OutboundLegId"]
        return_flight_id = trip["Itineraries"][0]["InboundLegId"]
        depart_company_id = trip["Legs"].find { |h| h['Id'] == depart_flight_id }["Carriers"]
        depart_OriginStation_id = trip["Legs"].find { |h| h['Id'] == depart_flight_id }["OriginStation"]
        depart_DestinationStation_id = trip["Legs"].find { |h| h['Id'] == depart_flight_id }["DestinationStation"]
        return_company_id = trip["Legs"].find { |h| h['Id'] == return_flight_id }["Carriers"]
        return_OriginStation_id = trip["Legs"].find { |h| h['Id'] == return_flight_id }["OriginStation"]
        return_DestinationStation_id = trip["Legs"].find { |h| h['Id'] == return_flight_id }["DestinationStation"]

        trips << {
          price: (trip["Itineraries"][0]["PricingOptions"][0]["Price"]).round(2),
          depart_date: trip["Legs"].find { |h| h['Id'] == depart_flight_id }["Departure"],
          depart_date_arrival: trip["Legs"].find { |h| h['Id'] == depart_flight_id }["Arrival"],
          depart_trip_duration: trip["Legs"].find { |h| h['Id'] == depart_flight_id }["Duration"],
          depart_company: trip["Carriers"].find { |h| h['Id'] == depart_company_id.join.to_i }["Code"],
          depart_OriginStation: trip["Places"].find { |h| h['Id'] == depart_OriginStation_id }["Code"],
          depart_DestinationStation: trip["Places"].find { |h| h['Id'] == depart_DestinationStation_id }["Code"],
          return_date: trip["Legs"].find { |h| h['Id'] == return_flight_id }["Departure"],
          return_date_arrival: trip["Legs"].find { |h| h['Id'] == return_flight_id }["Arrival"],
          return_trip_duration: trip["Legs"].find { |h| h['Id'] == return_flight_id }["Duration"],
          return_company: trip["Carriers"].find { |h| h['Id'] == return_company_id.join.to_i }["Code"],
          return_OriginStation: trip["Places"].find { |h| h['Id'] == return_OriginStation_id }["Code"],
          return_DestinationStation: trip["Places"].find { |h| h['Id'] == return_DestinationStation_id }["Code"],
          deep_link_url: trip["Itineraries"][0]["PricingOptions"][0]["DeeplinkUrl"]
        }
    end

    sorted_trips = trips.sort_by { |trip| trip[:price] }
    raise
  end
end

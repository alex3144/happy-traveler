require 'date'    # If not already required. If in Rails then you don't need this line).
require 'skyscanner'
require 'patches/skyscanner'

class GetFlightsService

  def initialize(search_params)
    @search_params = search_params
  end

  def call
    request_flight_result
  end

  private

  def processing_depart_segments(segment)

  end

  def request_flight_result

    # api_results = []
    # global_trips_results = []
    # exclude_airline_companies = []


    Skyscanner::Connection.url  = "partners.api.skyscanner.net/apiservices"
    Skyscanner::Connection.apikey = "prtl6749387986743898559646983194"
    Skyscanner::Connection.response_format = "ruby"


    api_results = []
    raw_results = []
    trips = []

    departure_date = @search_params[:departuredate].to_date
    return_date = @search_params[:returndate].to_date
    end_period_date =  @search_params[:end_period]

    # departure_date = ("2016-12-13").to_date
    # return_date = ("2016-12-20").to_date
    # end_period_date =  ("2017-01-13").to_date

    # while returndate <= end_period_date
    #   departuredate_to_string = (departure_date).to_s
    #   returndate_to_string = (returndate).to_s
    #   api_results = SacsRuby::API::InstaFlightsSearch.get(
    #     origin: @search_params[:origin],
    #     destination:  @search_params[:destination],
    #     departuredate:  departuredate_to_string,
    #     returndate:  returndate_to_string,
    #     limit: '5',
    #     sortby: "totalfare",
    #     order: "asc",
    #     excludedcarriers: exclude_airline_companies.join(",")
    #     # sortby2: "totalfare",
    #     # order2: "asc"
    #   )

    #   exclude_airline_companies << api_results["PricedItineraries"][0]["AirItinerary"]["OriginDestinationOptions"]["OriginDestinationOption"][0]["FlightSegment"][0]["MarketingAirline"]["Code"]

    #   api_results["PricedItineraries"].each do |trip|
    #     global_trips_results << trip
    #   end

    #   departure_date += 1
    #   returndate += 1
    # end
    # raise
  # global_trips_results
  # end
    i = 1
    while return_date <= end_period_date && i < 19
      departure_date_to_string = (departure_date).to_s
      return_date_to_string = (return_date).to_s
      api_results = Skyscanner::Connection.pricing({
        :country => "FR",
        :currency => "EUR",
        :locale => "fr-FR",
        :originPlace => @search_params[:origin] + "-sky",
        :destinationPlace => @search_params[:destination] + "-sky",
        # :stops => 1,
        :duration => 1440,
        # :pagesize => 1,
        :outboundPartialDate => departure_date,
        :inboundPartialDate => return_date
      })

      if api_results["Itineraries"] != [] && api_results["Legs"] != []
        raw_results << api_results
      end
      departure_date += 1
      return_date += 1
      i += 1
    end

      raw_results.each do |trip|
          depart_flight_id = trip["Itineraries"][0]["OutboundLegId"]
          return_flight_id = trip["Itineraries"][0]["InboundLegId"]
          depart_company_id = trip["Legs"].find { |h| h['Id'] == depart_flight_id }["Carriers"]
          depart_OriginStation_id = trip["Legs"].find { |h| h['Id'] == depart_flight_id }["OriginStation"]
          depart_DestinationStation_id = trip["Legs"].find { |h| h['Id'] == depart_flight_id }["DestinationStation"]
          depart_segments_id = trip["Legs"].find { |h| h['Id'] == depart_flight_id}["SegmentIds"]
          return_company_id = trip["Legs"].find { |h| h['Id'] == return_flight_id }["Carriers"]
          return_OriginStation_id = trip["Legs"].find { |h| h['Id'] == return_flight_id }["OriginStation"]
          return_DestinationStation_id = trip["Legs"].find { |h| h['Id'] == return_flight_id }["DestinationStation"]
          return_segments_id = trip["Legs"].find { |h| h['Id'] == return_flight_id}["SegmentIds"]

          # depart_segments_id.each do |segment|
          #   depart_segment_id = segment
          #   depart_segment_OriginStation_id =
          #   depart_segment_DestinationStation_id =
          #   depart_segment_company_id =
          #   depart_segments << {
          #     depart_segment_date:
          #     depart_segment_date_arrival:
          #     depart_segment_duration:
          #     depart_segment_company:
          #     depart_segment_OriginStation:
          #     depart_segment_DestinationStation:
          #   }
          # end

          # return_segments_id.each do |segment|
          #   return_segment_id = segment
          #   return_segment_date =
          #   return_segment_date_arrival =
          #   return_segment_OriginStation_id =
          #   return_segment_DestinationStation_id =
          #   return_segment_company_id =
          #   return_segment_duration =
          #   return_segments << {
          #     return_segment_date:
          #     return_segment_date_arrival:
          #     return_segment_duration:
          #     return_segment_company:
          #     return_segment_OriginStation:
          #     return_segment_DestinationStation:
          #   }
          # end

          trips << {
            price: (trip["Itineraries"][0]["PricingOptions"][0]["Price"]).round(2),
            depart_date: trip["Legs"].find { |h| h['Id'] == depart_flight_id }["Departure"],
            depart_date_arrival: trip["Legs"].find { |h| h['Id'] == depart_flight_id }["Arrival"],
            depart_trip_duration: Time.at((trip["Legs"].find { |h| h['Id'] == depart_flight_id }["Duration"])*60).utc.strftime("%Hh%M"),
            depart_company: trip["Carriers"].find { |h| h['Id'] == depart_company_id.join.to_i }["Code"],
            depart_OriginStation: trip["Places"].find { |h| h['Id'] == depart_OriginStation_id }["Code"],
            depart_DestinationStation: trip["Places"].find { |h| h['Id'] == depart_DestinationStation_id }["Code"],
            depart_segments_number: depart_segments_id.size - 1,
            return_date: trip["Legs"].find { |h| h['Id'] == return_flight_id }["Departure"],
            return_date_arrival: trip["Legs"].find { |h| h['Id'] == return_flight_id }["Arrival"],
            return_trip_duration: Time.at((trip["Legs"].find { |h| h['Id'] == return_flight_id }["Duration"])*60).utc.strftime("%Hh%M"),
            return_company: trip["Carriers"].find { |h| h['Id'] == return_company_id.join.to_i }["Code"],
            return_OriginStation: trip["Places"].find { |h| h['Id'] == return_OriginStation_id }["Code"],
            return_DestinationStation: trip["Places"].find { |h| h['Id'] == return_DestinationStation_id }["Code"],
            return_segments_number: return_segments_id.size - 1,
            deep_link_url: trip["Itineraries"][0]["PricingOptions"][0]["DeeplinkUrl"]
          }
      end
      raise
    sorted_trips = trips.sort_by { |trip| trip[:price] }
    if sorted_trips.size > 10
      first_ten_trips = sorted_trips[0..9]
    else
      sorted_trips
    end
  end
end






#   def processing(segment_result, stop_number)
#     {
#        start_segment_departure_airport: segment_result["DepartureAirport"]["LocationCode"],
#        start_segment_departure_datetime: segment_result["DepartureDateTime"],
#        start_segment_departure_timezone: segment_result["DepartureTimeZone"],
#        start_segment_arrival_airport: segment_result["ArrivalAirport"]["LocationCode"],
#        start_segment_arrival_datetime: segment_result["ArrivalDateTime"],
#        start_segment_arrival_timezone: segment_result["ArrivalTimeZone"],
#        start_segment_flight_number: segment_result["OperatingAirline"]["FlightNumber"],
#        start_segment_marketing_airline: segment_result["OperatingAirline"]["Code"],
#        stops: stop_number - 1
#     }
#   end

#   def stops_duration_calcul(segment, segment_number)
#     i = 0
#     duration_stop = 0
#     while i < segment_number - 1
#       duration_stop += (segment[i + 1]["DepartureDateTime"].to_time - segment[i]["ArrivalDateTime"].to_time).to_i / 60
#       i += 1
#     end
#     duration_stop
#   end

#   # def select_time_duration(results)
#   #   results.select { |record| raise record[:flight_values][2].last[:start_trip_duration] < 1440 && record[:flight_values][2].last[:return_trip_duration] < 1440 }
#   # end

#   def sort_by_price(results)
#     results.sort_by { |record| record[:flight_values][2].last[:price] }
#   end

#   def top5(results)
#     results[0..9]
#   end

#    def trip_generator(result)
#     trip = {}
#     trip[:depart_flights] = []
#     trip[:return_flights] = []
#     trip[:details] = {}
#       result[:flight_values][0].each_with_index do |flight, index|
#           flights_object_depart = Flight.new(departure_airport: flight[:start_segment_departure_airport],
#           departure_datetime: flight[:start_segment_departure_datetime],
#           departure_timezone: flight[:start_segment_departure_timezone],
#           arrival_airport: flight[:start_segment_arrival_airport],
#           arrival_datetime: flight[:start_segment_arrival_datetime],
#           arrival_timezone: flight[:start_segment_arrival_timezone],
#           flight_number: flight[:start_segment_flight_number],
#           marketing_airline: "http://0.omg.io/wego/image/upload/c_fit,w_200,h_70/flights/airlines_rectangular/" + flight[:start_segment_marketing_airline] + ".png",
#           step: index
#           )


#         trip[:depart_flights] << flights_object_depart
#       end
#       result[:flight_values][1].each_with_index do |flight, index|
#          flights_object_return = Flight.new(departure_airport: flight[:start_segment_departure_airport],
#           departure_datetime: flight[:start_segment_departure_datetime],
#           departure_timezone: flight[:start_segment_departure_timezone],
#           arrival_airport: flight[:start_segment_arrival_airport],
#           arrival_datetime: flight[:start_segment_arrival_datetime],
#           arrival_timezone: flight[:start_segment_arrival_timezone],
#           flight_number: flight[:start_segment_flight_number],
#           marketing_airline: "http://0.omg.io/wego/image/upload/c_fit,w_200,h_70/flights/airlines_rectangular/" + flight[:start_segment_marketing_airline] + ".png",
#           step: index
#           )

#         trip[:return_flights] << flights_object_return
#       end
#       trip[:details] = result[:flight_values][2][0]
#       trip
#     end




#   def flight_result(results_request)
#     raw_results = []
#     # Iteration to select only desired information sorted by flights
#     results_request.each do | result |
#       # depart_info = result["PricedItineraries"][0]["AirItinerary"]["OriginDestinationOptions"]["OriginDestinationOption"][0]
#       depart_segments_info = result["AirItinerary"]["OriginDestinationOptions"]["OriginDestinationOption"][0]["FlightSegment"]
#       depart_segment_number = depart_segments_info.size
#       return_segments_info = result["AirItinerary"]["OriginDestinationOptions"]["OriginDestinationOption"][1]["FlightSegment"]
#       # return_info = result["PricedItineraries"][0]["AirItinerary"]["OriginDestinationOptions"]["OriginDestinationOption"][1]
#       return_segment_number = return_segments_info.size
#       itin_fares = result["AirItineraryPricingInfo"]["ItinTotalFare"]

#       i = results_request.index(result) + 1
#       flights_info = {}
#       flights_info[:flight_id] = i
#       flights_info[:flight_values] = []
#       flights_info[:flight_values][0] = []
#       flights_info[:flight_values][1] = []
#       flights_info[:flight_values][2] = []
#       depart_segment_results = []
#       return_segment_results = []
#       price_results = []
#       depart_flight_duration = 0
#       return_flight_duration = 0

#       depart_segments_info.each do | segment_result |
#         flights_info[:flight_values][0] <<  processing(segment_result, depart_segment_number)
#         depart_flight_duration += segment_result["ElapsedTime"]
#       end

#       return_segments_info.each do | segment_result |
#         flights_info[:flight_values][1] << processing(segment_result, return_segment_number)
#         return_flight_duration += segment_result["ElapsedTime"]
#       end

#       depart_stops_duration = stops_duration_calcul(depart_segments_info, depart_segment_number)
#       return_stops_duration = stops_duration_calcul(return_segments_info, return_segment_number)

#       flights_info[:flight_values][2] << { price: itin_fares["TotalFare"]["Amount"],
#         currency: result["AirItineraryPricingInfo"]["ItinTotalFare"]["TotalFare"]["CurrencyCode"],
#         start_trip_duration: depart_flight_duration + depart_stops_duration,
#         return_trip_duration: return_flight_duration + return_stops_duration
#         # start_trip_duration: Time.at((depart_flight_duration + depart_stops_duration)*60).utc.strftime("%Hh%M"),
#         # return_trip_duration: Time.at((return_flight_duration + return_stops_duration)*60).utc.strftime("%Hh%M")
#       }
#       raw_results << flights_info

#     end

#     # selected_results = select_time_duration(raw_results)
#     sorted_results = sort_by_price(raw_results)
#     top5_results = top5(sorted_results)

#     trips = []
#     top5_results.each do |result|
#       trips << trip_generator(result)
#     end
#     trips
#   end
# end




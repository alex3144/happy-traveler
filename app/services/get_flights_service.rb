class GetFlightsService
  def initialize(search_params)
    @search_params = search_params
  end

  def call
    flight_result(request_flight_result)
  end

  private

  def request_flight_result
    flight_search_result = []
    departure_date = @search_params[:departuredate].to_date
    returndate = @search_params[:returndate].to_date
    end_period_date =  @search_params[:end_period]

    while returndate <= end_period_date
      departuredate_to_string = (departure_date).to_s
      returndate_to_string = (returndate).to_s
      flight_search_result << SacsRuby::API::InstaFlightsSearch.get(
        origin: @search_params[:origin],
        destination:  @search_params[:destination],
        departuredate:  departuredate_to_string,
        returndate:  returndate_to_string, limit: '1'
      )

      departure_date += 1
      returndate += 1
    end
    flight_search_result
  end



  def processing(array, segment_result, stop_number)
    array << {
       start_segment_departure_airport: segment_result["DepartureAirport"]["LocationCode"],
       start_segment_departure_datetime: segment_result["DepartureDateTime"],
       start_segment_departure_timezone: segment_result["DepartureTimeZone"],
       start_segment_arrival_airport: segment_result["ArrivalAirport"]["LocationCode"],
       start_segment_arrival_datetime: segment_result["ArrivalDateTime"],
       start_segment_arrival_timezone: segment_result["ArrivalTimeZone"],
       start_segment_flight_number: segment_result["OperatingAirline"]["FlightNumber"],
       start_segment_marketing_airline: segment_result["OperatingAirline"]["Code"],
       stops: stop_number - 1
    }
  end

  def stops_duration_calcul(segment, segment_number)
    i = 0
    duration_stop = 0
    while i < segment_number - 1
      duration_stop += (segment[i + 1]["DepartureDateTime"].to_time - segment[i]["ArrivalDateTime"].to_time).to_i / 60
      i += 1
    end
    duration_stop
  end


  def flight_result(results_request)
    raw_results = []
    # Iteration to select only desired information sorted by flights
    results_request.each do | result |
      # depart_info = result["PricedItineraries"][0]["AirItinerary"]["OriginDestinationOptions"]["OriginDestinationOption"][0]
      depart_segments_info = result["PricedItineraries"][0]["AirItinerary"]["OriginDestinationOptions"]["OriginDestinationOption"][0]["FlightSegment"]
      depart_segment_number = depart_segments_info.size
      return_segments_info = result["PricedItineraries"][0]["AirItinerary"]["OriginDestinationOptions"]["OriginDestinationOption"][1]["FlightSegment"]
      # return_info = result["PricedItineraries"][0]["AirItinerary"]["OriginDestinationOptions"]["OriginDestinationOption"][1]
      return_segment_number = return_segments_info.size

      i = results_request.index(result) + 1
      flights_info = {}
      flights_info[:flight_id] = i
      flights_info[:flight_values] = []
      depart_segment_results = []
      return_segment_results = []
      price_results = []
      depart_flight_duration = 0
      return_flight_duration = 0

      depart_segments_info.each do | segment_result |
        processing(flights_info[:flight_values], segment_result, depart_segment_number)
        depart_flight_duration += segment_result["ElapsedTime"]
      end

      return_segments_info.each do | segment_result |
        processing(flights_info[:flight_values], segment_result, return_segment_number)
        return_flight_duration += segment_result["ElapsedTime"]
      end


      depart_stops_duration = stops_duration_calcul(depart_segments_info, depart_segment_number)
      return_stops_duration = stops_duration_calcul(return_segments_info, return_segment_number)


      flights_info[:flight_values] << { price: result["PricedItineraries"][0]["AirItineraryPricingInfo"]["ItinTotalFare"]["TotalFare"]["Amount"],
        currency: result["PricedItineraries"][0]["AirItineraryPricingInfo"]["ItinTotalFare"]["TotalFare"]["CurrencyCode"],
        start_trip_duration: depart_flight_duration + depart_stops_duration,
        return_trip_duration: return_flight_duration + return_stops_duration
      }
      raw_results << flights_info
    end
    raw_results
  end
end




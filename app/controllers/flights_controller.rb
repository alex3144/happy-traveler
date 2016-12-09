require 'date'    # If not already required. If in Rails then you don't need this line).

class FlightsController < ApplicationController
  token = SacsRuby.client.fetch_token
  token.access_token
  token.expires_on

  def index
    # User Params
    params[:periode] = params[:periode].downcase.capitalize
    start_period = date_params(params[:periode])[1]
    end_periode = date_params(params[:periode])[0]
    lengthofstay = params[:duration].join

    search_params = {
      origin: params[:departure],
      destination: params[:destination],
      lengthofstay: params[:duration].join,
      end_period: end_periode.to_date,
      departuredate: start_period,
      returndate: (start_period.to_date + lengthofstay.to_i).to_s
    }

    @trips_results = ::GetFlightsService.new(search_params).call
  end

  def autocomplete
    # @list = ::AutoCompleteService.new(params[:query]).call
    @list = ["nantes","bordeaux","toulouse"]
    respond_to do |format|
      format.js { render "autocomplete" }
    end
  end

  private

  def sort_by_duration(results)
  end

  def date_params(date)

    last_day_hash = {
      "Janvier" => "31",
      "Février" => "28",
      "Mars" => "31",
      "Avril" => "30",
      "Mai" => "31",
      "Juin" => "30",
      "Juillet" => "31",
      "Aout" => "31",
      "Septembre" => "30",
      "Octobre" => "31",
      "Novembre" => "30",
      "Decembre" => "31",

    };



    month_hash = {
      "Janvier" => "01",
      "Février" => "02",
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

    results = ["2017" + "-" + month_hash[date] +"-" + last_day_hash[date],
    "2017" + "-" + month_hash[date] + "-01"]
  end
end




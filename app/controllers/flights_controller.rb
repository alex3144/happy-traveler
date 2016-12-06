require 'date'    # If not already required. If in Rails then you don't need this line).

class FlightsController < ApplicationController

  token = SacsRuby.client.fetch_token
  token.access_token
  token.expires_on

  def home

  end

  def index

    # User Params

    lengthofstay = "5" # coresspond au .times fois la requete a effectuer avec un decalage de lenthofday jour a chaque fois
    start_period = Date.today
    end_period = "2017-02-06".to_date

    raise
    origin1 = "JFK"
    destination1 = "CDG"
    departuredate1 = '2016-12-18'
    departuredate = results1["FareInfo"].first["DepartureDateTime"].slice(/^.{0,10}/)
    returndate = (DateTime.parse(departuredate).to_date + lengthofstay.to_i).to_s

    # Premiere requete qui utilise les params ci-dessus a mettre dans un boucle ou on fait varier les dates

    flight_search_result = SacsRuby::API::InstaFlightsSearch.get(origin: origin, destination: destination, departuredate: departuredate, returndate: returndate,  includecarriers: includecarriers, maxfare: price.to_s, limit: '1')

    raise

    # Trier les X moins chere parmis les differents créneaux

  end

end

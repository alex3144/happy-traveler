class AutoCompleteService

  def initialize(search_destination)
    @search_destination = search_destination
  end

  def call
    processing(autocomplete)
  end

  def autocomplete
    SacsRuby::API::GeoAutocomplete.get(query: @search_destination, limit: 5)
  end

  def processing(list)
    airports_list = []
    request_result =  list["Response"]["grouped"]["category:AIR"]["doclist"]["docs"]
    request_result.each do |airport|
      airports_list << airport["city"] + "-" + airport["countryName"] + "(" + airport["id"]+")"
    end
    airports_list
  end
end

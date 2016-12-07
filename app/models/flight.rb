class Flight
  include ActiveModel::Model
  attr_accessor :departure_airport,
                :departure_datetime,
                :departure_timezone,
                :arrival_airport,
                :arrival_datetime ,
                :arrival_timezone,
                :flight_number,
                :marketing_airline
end

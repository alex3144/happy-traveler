class PagesController < ApplicationController
  def home
    @periode = month_ordered
    @passagers_number = ["0","1","2","3","4","5"]
  end

  def month_ordered
    placeholder = "Choisissez votre période"
    date = Time.now
    actual_month = date.month - 1
    actual_year = date.year
    last_months = []
    first_months = []
    months = ["Janvier","Février","Mars","Avril","Mai","Juin","Juillet","Août","Septembre","Octobre","Novembre","Décembre"]
    months.map.with_index do |x, i|
      if i < actual_month
        x = x + " " + "#{actual_year + 1}"
        last_months << x
      else
        x = x + " " + "#{actual_year}"
        first_months << x
      end
    end
    results = first_months + last_months
    results.unshift(placeholder)
    return results

  end
end

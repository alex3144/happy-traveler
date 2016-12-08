class PagesController < ApplicationController
  def home
    @periode = ["Choisissez votre période","Janvier","Février","Mars","Avril","Mai","Juin","Juillet","Août","Septembre","Octobre","Novembre","Décembre"]
    @passagers_number = ["0","1","2","3","4","5"]

  end
end

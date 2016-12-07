class PagesController < ApplicationController
  def home
    @periode = ["Choisissez votre période","Janvier","Février","Mars","Avril","Mai","Juin","Juillet","Août","Septembre","Octobre","Novembre","Décembre"]
  end
end

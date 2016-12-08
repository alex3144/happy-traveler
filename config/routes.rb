Rails.application.routes.draw do
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :flights, only: [:index]
  get "autocomplete" , to: 'flights#autocomplete'
end

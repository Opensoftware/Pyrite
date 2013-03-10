SiatkaGit::Application.routes.draw do

  devise_for :users

  match "/siatka" => "siatka#index", :as => "siatka"
  match "/howto" => "main#howto", :as => "howto"
  match "/contact" => "main#kontakt", :as => "contact"
  resources :schedules
  resource :settings, :only => [:edit, :update]
  root :to => 'main#index'

  resources :freedays
  resources :rooms do
    collection do
      get :auto_complete_for_room_numer
    end
  end
  resources :siatka
  # TODO replace by resources
  get ":controller/:action/:id"
  get ":controller/:action"

end

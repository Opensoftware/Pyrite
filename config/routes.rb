SiatkaGit::Application.routes.draw do

  devise_for :users

  match "/siatka" => "siatka#index", :as => "siatka"
  match "/howto" => "main#howto", :as => "howto"
  match "/contact" => "main#kontakt", :as => "contact"

  # TODO replace by resources
  match "/siatka/rezerwacja" => "siatka#rezerwacja"
  match "/siatka/rrezerwacja" => "siatka#rrezerwacja"
  match "/siatka/addrez" => "siatka#addrez"
  match "/siatka/formularz" => "siatka#formularz"
  match "/siatka/add" => "siatka#add"
  match "/siatka/adding" => "siatka#adding"
  match "/siatka/edit" => "siatka#edit"
  match "/siatka/preview" => "siatka#preview"
  match "/siatka/admin" => "siatka#admin"
  match "/siatka/kolizje" => "siatka#kolizje"
  match "/siatka/kolizjegrup" => "siatka#kolizjegrup"
  match "/siatka/drukowanie" => "siatka#drukowanie"
  match "/siatka/statystyki" => "siatka#statystyki"


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

end

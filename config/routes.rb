Pyrite::Application.routes.draw do

  namespace :block do
    resources :types, :except => [:show]
  end

  devise_for :users

  match "/howto" => "main#howto", :as => "howto"
  match "/contact" => "main#contact", :as => "contact"

  resources :groups, :except => [:show] do
    member do
      get :timetable
    end
    collection do
      get :timetables
    end
  end
  resources :academic_years do
    resources :events, :controller => "academic_years/events"
  end
  get "academic_years/events/fetch", :as => "events_for_academic_year", :to => "academic_years/events#fetch"
  resources :blocks, :except => [:index]
  resources :reservations, :only => [:new, :create] do
    collection do
     get  ":room_id/show", :to => "reservations#show", :as => "show"
    end
  end

  resource :settings, :only => [:edit, :update]
  root :to => 'main#index'

  resources :buildings do
    resources :rooms, :only => [:new]
  end
  resources :rooms, :except => [:index] do
    member do
      get :timetable
    end
    collection do
      get :auto_complete_for_room_numer
      get :timetables
    end
  end
  resources :dashboard, :only => [:index]

  resources :lecturers, :except => [:show]

  get "/lecturer/:id/timetable", :to => "lecturers#timetable", :as => "timetable_lecturer"

  match "/user/account" => "users#account", :as => "user_account", :via => :get
  match "/user/update" => "users#update", :as => "update_user_account", :via => :put

end

SiatkaGit::Application.routes.draw do

  namespace :block do
    resources :types, :except => [:show]
  end

  devise_for :users

  match "/howto" => "main#howto", :as => "howto"
  match "/contact" => "main#kontakt", :as => "contact"

  resources :groups do
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
  resources :blocks, :only => [:new, :create]

  resource :settings, :only => [:edit, :update]
  root :to => 'main#index'

  resources :rooms do
    member do
      get :timetable
    end
    collection do
      get :auto_complete_for_room_numer
      get :timetables
    end
  end
  resources :dashboard, :only => [:index]

end

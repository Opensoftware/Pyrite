Pyrite::Engine.routes.draw do

  namespace :block do
    resources :types, :except => [:show]
  end

  match "/howto" => "main#howto", :as => "howto", :via => :get
  match "/contact" => "main#contact", :as => "contact", :via => :get


  resource :timetable, :only => [] do
    get "groups", :to => "groups#timetables"
    get "groups_for_meeting", :to => "groups#timetables_for_meeting"
    get "groups/:event_id/print", :to => "groups#print_all", :as => :print_all_groups
    get "groups/:id/:event_id/print", :to => "groups#print", :as => :print_group
    get "groups/:id", :to => "groups#timetable", :as => :group

    get "rooms", :to => "rooms#timetables"
    get "rooms_for_meeting", :to => "rooms#timetables_for_meeting"
    get "room/:id", :to => "rooms#timetable", :as => :room
    get "rooms/:event_id/print", :to => "rooms#print_all", :as => :print_all_rooms
    get "rooms/:id/:event_id/print", :to => "rooms#print", :as => :print_room

    get "lecturer/:id", :to => "lecturers#timetable", :as => :lecturer
  end
  resources :groups, :except => [:show]
  get "/blocks/new_part_time", :as => :new_part_time_block, :to => "blocks#new_part_time"
  post "/blocks/new_part_time", :as => :part_time_block, :to => "blocks#create_part_time"
  resources :blocks, :except => [:index] do
    member do
      patch :move
      patch :resize
    end
  end

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
  resources :rooms, :except => [:index, :show]
  resources :dashboard, :only => [:index] do
    collection do
      get :prints
      get :prints_part_time
    end
  end

  match "/user/account" => "users#account", :as => "user_account", :via => :get
  match "/user/update" => "users#update", :as => "update_user_account", :via => :put

end

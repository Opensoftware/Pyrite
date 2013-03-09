SiatkaGit::Application.routes.draw do


  resources :schedules
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

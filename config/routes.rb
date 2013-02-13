ActionController::Routing::Routes.draw do |map|
  map.resources :schedules




 map.root :controller => "main"

  map.resources :freedays
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.resources :rooms, :collection => {:auto_complete_for_room_numer => :get }
  map.resources :siatka
  map.connect "*anything" , :controller => "main", :action => "render_404"
end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/main_page' => 'application#main_dashboard'
  post 'add_app' => 'application#add_app'
  # get '/add_delete_app' => 'application#add_delete_app'
end

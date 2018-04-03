Rails.application.routes.draw do
  get 'rooms/index(/:latitude/:longitude)' => 'rooms#index'
  post 'rooms/create(/:latitude/:longitude)' => 'rooms#create'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

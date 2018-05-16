Rails.application.routes.draw do
  # room情報の取得
  get 'rooms/index(/:latitude/:longitude)' => 'rooms#index'
  post 'rooms/create(/:latitude/:longitude)' => 'rooms#create'

  # room内の投稿情報を取得
  get 'posts/index(/:latitude/:longitude/:id)' => 'posts#index'
  post 'posts/create(/:latitude/:longitude/:id)' => 'posts#create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

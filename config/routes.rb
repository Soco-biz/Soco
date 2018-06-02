Rails.application.routes.draw do
  # room情報の取得
  get 'rooms/index(/:latitude/:longitude)' => 'rooms#index'
  post 'rooms/create(/:latitude/:longitude)' => 'rooms#create'

  # room内の投稿情報を取得
  get 'posts/index(/:latitude/:longitude/:id)' => 'posts#index'
  post 'posts/create(/:latitude/:longitude/:id)' => 'posts#create'

  # soco_posts情報
  get 'soco_posts/index(/:latitude/:longitude/:id)' => 'soco_posts#index'
  get 'soco_posts/reload(/:latitude/:longitude/:last_id/:id)' => 'posts#auto_reload'
  post 'soco_posts/create(/:latitude/:longitude/:id)' => 'soco_posts#create'
  post 'soco_posts/favorite(/:latitude/:longitude/:id)' => 'soco_posts#favorite'
  # soco_tags情報
  get 'soco_tags/index(/:latitude/:longitude/:id)' => 'soco_tags#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

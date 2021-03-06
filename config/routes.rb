Rails.application.routes.draw do
  # soco_posts情報
  get 'soco_posts/index(/:latitude/:longitude)' => 'soco_posts#index'
  post 'soco_posts/create(/:latitude/:longitude)' => 'soco_posts#create'
  post 'soco_posts/favorite(/:latitude/:longitude)' => 'soco_posts#favorite'
  # soco_tags情報
  get 'soco_tags/index(/:latitude/:longitude/:id)' => 'soco_tags#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

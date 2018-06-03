json.lounge do
  json.array! @lounge, partial: 'soco_posts/post', as: :post
end

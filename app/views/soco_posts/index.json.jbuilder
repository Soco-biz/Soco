json.lounge do
  json.posts do
    json.array! @lounge, partial: 'soco_posts/post', as: :post
  end
  json.replies do
    json.array! @to_reply, partial: 'soco_posts/reply', as: :reply
  end
end

json.lounge do
  json.post do
    json.array! @lounge, partial: 'soco_posts/post', as: :post
  end
  json.reply do
    json.array! @to_reply, partial: 'soco_posts/reply', as: :reply
  end
end

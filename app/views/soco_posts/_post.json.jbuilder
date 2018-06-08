json.id post.id
json.contents post.contents
json.reply post.reply
json.good post.good
json.image post.image
json.tag do
  json.array! post.tag_list, partial: 'soco_posts/tag', as: :tag
end
json.created_at post.created_at

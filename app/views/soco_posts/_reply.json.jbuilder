json.id reply.id
json.contents reply.contents
json.reply reply.reply
json.good reply.good
json.image reply.image
json.tag do
  json.array! reply.tag_list, partial: 'soco_posts/tag', as: :tag
end
json.created_at reply.created_at
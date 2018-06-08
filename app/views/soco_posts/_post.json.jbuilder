json.id post.id
json.contents post.contents
json.reply post.reply
# if json.reply.nil?
#   json.reply post.reply
# else
#   json.array! post.reply, partial: 'soco_posts/reply', as: :reply
# end
json.good post.good
json.image post.image
json.tag do
  json.array! post.tag_list, partial: 'soco_posts/tag', as: :tag
end
json.created_at post.created_at
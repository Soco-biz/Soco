json.id post.id
json.contents post.contents
json.reply post.reply
json.good post.good
json.image post.image
json.tag(post.tags.pluck(:name)) do |tag|
  json.name tag
end
json.created_at post.created_at

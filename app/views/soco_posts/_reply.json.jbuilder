json.id reply.id
json.contents reply.contents
json.reply reply.reply
json.good reply.good
json.image reply.image
json.tag(reply.tags.pluck(:name)) do |tag|
  json.name tag
end
json.created_at reply.created_at

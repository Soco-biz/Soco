if @rooms_id == 1
  json.info @lounge
else
  json.info @rooms_info.posts, :id, :contents, :good, :bad
end

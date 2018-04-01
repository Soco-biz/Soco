if @error == 1
  json.info do
    json.error @error
  end
else
  json.info @post_room
end

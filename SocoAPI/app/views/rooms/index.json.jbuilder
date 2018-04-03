json.info do
  json.around do
    json.array! @around_room, :name
  end
  json.local do
    json.array! @local_room, :name
  end
  json.state do
    json.array! @state_room, :name
  end
end


json.info do
  json.small do
    json.array! @small_room , :name
  end
  json.middle do
    json.array! @middle_room, :name
  end
  json.large do
    json.array! @large_room, :name
  end
end


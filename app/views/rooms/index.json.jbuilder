json.info do
  json.lounge do
    json.array! @lounge
  end
  json.small do
    json.array! @small_room
  end
  json.middle do
    json.array! @middle_room
  end
  json.large do
    json.array! @large_room
  end
end


json.info do
  json.lounge do
    json.array! @lounge, :id, :contents, :good, :bad, :image
  end
  json.small do
    json.array! @small_room , :id, :name, :image
  end
  json.middle do
    json.array! @middle_room, :id, :name, :image
  end
  json.large do
    json.array! @large_room, :id, :name, :image
  end
end


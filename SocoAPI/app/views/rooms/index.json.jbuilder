if @error == 1
  json.info do
    json.error @error
  end
else
  json.info do
    json.close_room do
      json.array! @close_room, :name
    end
    json.local_room do
      json.array! @local_room, :name
    end
    json.state_room do
      json.array! @state_room, :name
    end
  end
end

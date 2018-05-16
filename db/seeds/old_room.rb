# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

seeds = [
  {
    name: "ラウンジ",
    latitude: -1,
    longitude: -1
  },
  {
    name: "中央大学",
    latitude: 35.6413913,
    longitude: 139.4056186
  },
  {
    name: "中央大学・明星大学駅",
    latitude: 35.641927,
    longitude: 139.408568
  },
  {
    name: "立川駅",
    latitude: 35.697914,
    longitude: 139.413741
  },
  {
    name: "新宿駅",
    latitude: 35.691391,
    longitude: 139.705983,
  }
]

seeds.size.times do |i|
  num = i+1
  Room.create(
    id: num,
    name: seeds[i][:name],
    latitude: seeds[i][:latitude],
    longitude: seeds[i][:longitude]
  )
end

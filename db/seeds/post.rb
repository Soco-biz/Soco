# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

rooms_id = 0
good = 0
bad = 0
100.times do |i|
  num = i+1
  rooms_id = i % 20 == 0 ? rooms_id+1 : rooms_id
  good = i % 10 == 0 ? good+1 : good
  bad = i % 20 == 0 ? bad+1 : bad

  Post.create(
    id: num,
    contents: "この投稿はrooms_id: #{rooms_id}です",
    good: good,
    bad: bad,
    rooms_id: rooms_id
  )
end


class Room < ApplicationRecord
  # TODO: あとで条件式(30分以後の投稿は取得しない)を追加
  has_many :posts, foreign_key: 'rooms_id'

  acts_as_mappable :lat_column_name => :latitude, :lng_column_name => :longitude
  Geocoder.configure
end

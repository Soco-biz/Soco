class SocoTag < ApplicationRecord
  has_many :soco_post

  acts_as_mappable :lat_column_name => :latitude, :lng_column_name => :longitude
  Geocoder.configure
end

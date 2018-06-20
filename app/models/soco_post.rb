class SocoPost < ApplicationRecord
  acts_as_taggable

  acts_as_mappable :lat_column_name => :latitude, :lng_column_name => :longitude
  Geocoder.configure
  
  validates :latitude, :longitude,
    location: true
  validates :contents,
    presence: true,
    length: { minimum: 1, maximum: 140 }
end
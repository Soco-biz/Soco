class SocoPost < ApplicationRecord
  acts_as_taggable
  acts_as_taggable_on :contents, :latitude, :longitude

  acts_as_mappable :lat_column_name => :latitude, :lng_column_name => :longitude
  Geocoder.configure
end

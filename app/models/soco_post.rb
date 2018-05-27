class SocoPost < ApplicationRecord
  # 新規に作る場合はデフォルトで確認しにいくのでoptional: true指定
  belongs_to :soco_tag, optional: true

  acts_as_mappable :lat_column_name => :latitude, :lng_column_name => :longitude
  Geocoder.configure
end

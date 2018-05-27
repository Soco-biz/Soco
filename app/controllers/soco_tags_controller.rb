class SocoTagsController < ApplicationController
  before_action :soco_tags_params

  def soco_tags_params
    params.require().permit(:tag_name, :latitude, :longitude)
  end
end

class SocoPostsController < ApplicationController
  before_action :soco_posts_params

  def index
  end

  def create
  end

  def favorite
  end

  def soco_posts_params
    params.require(:soco_posts).permit(
      :contents,
      :reply,
      :good,
      :first_tag_id,
      :second_tag_id,
      :third_tag_id,
      :latitude,
      :longitude,
      :image
    )
  end
end

class SocoTagsController < ApplicationController
  before_action :soco_tags_params

  def index
    @tag_info = []
    lounge = SocoPost.within(0.5, origin: [@latitude, @longitude])

    lounge.each do |post|
      post.tag_list
    end
  end
end

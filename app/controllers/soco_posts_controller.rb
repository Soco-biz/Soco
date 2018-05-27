class SocoPostsController < ApplicationController
  before_action :take_location, only: [:index, :create]

  def index
    @lounge = SocoPost.within(1.0, origin: [@latitude, @longitude])
                      .select(
                        :id,
                        :contents,
                        :reply,
                        :good,
                        :first_tag_id,
                        :second_tag_id,
                        :third_tag_id,
                        :image,
                        :updated_at
                      ).order(updated_at: :desc)
  end

  def create
  end

  def favorite
  end

  # 緯度経度,市町村区,都道府県を取得する
  def take_location
    if params[:latitude] == 'null' || params[:longitude] == 'null'
      render formats: 'json', status: :not_found
    end

    @latitude = params[:latitude].to_f
    @longitude = params[:longitude].to_f
  end

  # tag_idは受け取ったtag_nameをidに変換してからparamsにいれる必要がある
  def soco_posts_params
    params.require(:soco_post).permit(
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

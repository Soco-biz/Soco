class SocoPostsController < ApplicationController
  before_action :take_location, only: [:index, :create, :favorite, :auto_reload]

  def index
    if @latitude == 0 || @longitude == 0
      render formats: 'json', status: :not_found
    end
    # 直接ラウンジ内に表示する投稿だけを追加する
    @lounge = SocoPost.within(0.2, origin: [@latitude, @longitude])
                      .select(:id, :contents, :reply, :good, :image, :created_at)
                      .includes(:tags)
                      .where(reply: nil)
                      .limit(100)
                      .order(updated_at: :desc)
    # リプライIDを持っているものだけを取得
    # TODO: loungeの一番古い投稿の、update_atより後に投稿されたリプライだけを取得する
    @to_reply = SocoPost.within(0.2, origin: [@latitude, @longitude])
                        .select(:id, :contents, :reply, :good, :image, :created_at)
                        .includes(:tags)
                        .where.not(reply: nil)
                        .order(updated_at: :desc)
  end

  def create
    @posts = SocoPost.new(soco_posts_params)
    @posts[:latitude] = @latitude
    @posts[:longitude] = @longitude
    tags = params[:soco_post][:tag]
    reply_id = params[:soco_post][:reply]

    if tags.present?
      tags.split(',').each do |tag|
        @posts.tag_list.add(tag)
      end
    end

    if @posts.save
      if reply_id.present?
        to_reply = SocoPost.find(reply_id)
        to_reply.touch # リプライ先のupdated_atだけを更新
      end
      Pusher.trigger('lounge', 'chat', {
        'contents': params[:soco_post][:contents],
        'reply': params[:soco_post][:reply].to_i,
        'image': params[:soco_post][:image],
        'tag': params[:soco_post][:tag],
        'id': @posts.id,
        'latitude': @latitude,
        'longitude': @longitude,
        'created_at': @posts.created_at
      })
      render formats: 'json', status: :created
    else
      render formats: 'json', status: :unprocessable_entity
    end
  end

  def favorite
    posts_id = params[:soco_post][:id]
    @posts = SocoPost.find(posts_id) # いいねを更新する投稿先情報を取得
    soco_params = soco_posts_params # 更新用のガワを用意する
    soco_params[:good] = soco_params[:good].to_i + 1 # いいねを1増やす

    if accept_favorite(posts_id)
      @posts.record_timestamps = false
      if @posts.update(soco_params)
        @posts.record_timestamps = true
        render formats: 'json', status: :accepted
      else
        render formats: 'json', status: :unprocessable_entity
      end
    else
      render formats: 'json', status: :not_acceptable
    end
  end

  private
  # 緯度経度を取得する
  def take_location
    @latitude = params[:latitude].to_f
    @longitude = params[:longitude].to_f
  end

  # いいねするための投稿が範囲内にあるか
  def accept_favorite(posts_id)
    favorite_flag = SocoPost.within(1.0, origin: [@latitude, @longitude])
                            .where(id: posts_id)
                            .exists?
  end

  def soco_posts_params
    params.require(:soco_post).permit(
      :contents,
      :reply,
      :good,
      :latitude,
      :longitude,
      :image,
      :tag_list
    )
  end
end

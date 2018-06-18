class SocoPostsController < ApplicationController
  before_action :take_location, only: [:index, :create, :favorite, :auto_reload]

  def index
    minutes = 30 * 60 # Socoの取得時間制限
    limit_time = Time.current - minutes
    # リプライIDを持ってるものは省く処理を追加する
    @lounge = SocoPost.within(1.0, origin: [@latitude, @longitude])
                      .where('updated_at >= ?', limit_time)
                      .where(reply: nil)
                      .order(updated_at: :desc)
    # リプライIDを持っているものだけを取得
    @to_reply = SocoPost.within(1.0, origin: [@latitude, @longitude])
                        .where('updated_at >= ?', limit_time)
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

    if reply_id.present?
      to_reply = SocoPost.find(reply_id)
      to_reply.touch # リプライ先のupdated_atだけを更新
    end

    if @posts.save
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
      if @posts.update(soco_params)
        render formats: 'json', status: :accepted
      else
        render formats: 'json', status: :unprocessable_entity
      end
    else
      render formats: 'json', status: :not_acceptable
    end
  end

  def auto_reload
    last_id = params[:last_id].to_i + 1
    @new_posts = SocoPost.within(1.0, origin: [@latitude, @longitude])
                                  .where(id: last_id...Float::INFINITY)
                                  .order(id: :asc)
    render formats: 'json', status: :ok
  end

  private
  # 緯度経度,市町村区,都道府県を取得する
  def take_location
    if params[:latitude] == 'null' || params[:longitude] == 'null'
      render formats: 'json', status: :not_found
    end

    @latitude = params[:latitude].to_f
    @longitude = params[:longitude].to_f
  end

  # いいねするための投稿が範囲内にあるか
  def accept_favorite(posts_id)
    favorite_flag = SocoPost.within(1.0, origin: [@latitude, @longitude])
                            .where(id: posts_id)
                            .exists?
  end

  # tag_idは受け取ったtag_nameをidに変換してからparamsにいれる必要がある
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

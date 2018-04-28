class PostsController < ApplicationController
  before_action :judge_access_post, only: [:index, :create]
  """
  @parameter: ?latitude=float&logitude=float&id=integer
  """
  # room内の投稿を取得する.ラウンジの時だけ特殊処理
  def index
    @rooms_info = Room.find(params[:id].to_i)
    if @rooms_id == 1
      @lounge = lounge_info
      render formats: 'json', status: :ok
    end

    if @flag == 0
      render formats: 'json', status: :ok
    elsif @flag == 1
      render formats: 'json', status: :accepted
    else
      render formats: 'json', status: :not_acceptable
    end

  end

  def create
    # 投稿するメソッド
  end

  private

  # loungeだけは特別処理
  def lounge_info
    lounge = Post.within(0.2, origin: [@latitude, @longitude])
                  .select(:id, :contents, :good, :bad)
                  .where(rooms_id: 1)
                  .order(created_at: :desc)
  end

  # 部屋へのアクセス, 投稿権限と必要なパラメータがあるか調べる
  def judge_access_post
    if params[:latitude].nil? || params[:longitude].nil? || params[:id].nil?
      render formats: 'json', status: :not_found
    end

    rooms_id = params[:id].to_i
    latitude = params[:latitude].to_f
    longitude = params[:longitude].to_f

    @flag = survey_rooms(rooms_id, latitude, longitude)
  end

  # roomsモデル内へ権限調査
  def survey_rooms(rooms_id, latitude, longitude)
    write_flag = Room.within(0.2, origin: [latitude, longitude])
                     .where(id: rooms_id)
                     .exists?
    access_flag = Room.within(1.0, origin: [latitude, longitude])
                      .where(id: rooms_id)
                      .exists?

    # 0 -> 投稿も可能, 1 -> アクセスのみ, 2 -> アクセス不可
    if write_flag == true
      0
    elsif access_flag == true
      1
    else
      2
    end
  end

  def post_params
    params.require(:posts).permit(:contents, :good, :bad)
  end
end

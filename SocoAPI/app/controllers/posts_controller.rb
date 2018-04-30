class PostsController < ApplicationController
  before_action :judge_access_post, only: [:index, :create]
  """
  @parameter: ?latitude=float&logitude=float&id=integer
  rooms_id: 1はラウンジを指す
  """
  # room内の投稿を取得する. ラウンジの時だけ特殊処理
  def index
    @rooms_info = Room.find(@rooms_id)
    if @rooms_id == 1
      lounge_posts
      return
    end

    if @flag == 0
      render formats: 'json', status: :ok
    elsif @flag == 1
      render formats: 'json', status: :accepted
    else
      render formats: 'json', status: :not_acceptable
    end
  end

  """
  @parameter: ?latitude=float&logitude=float?id=integer
  content-type: application/x-www-form-urlencoded
  -d room[name]=room_name
  """
  # 投稿するメソッド. ラウンジの時だけ特殊処理
  def create
    render formats: 'json', status: :not_acceptable if @flag != 0

    post_info = Post.new(post_params)
    @post_posts = create_post_info(post_info)

    if @post_posts.save
      render formats: 'json', status: :created
    else
      render formats: 'json', status: :unprocessable_entity
    end
  end

  private

  # loungeだけは特別処理
  def lounge_posts
    # @loungeはまだ緯度経度を取得していない
    @lounge = Post.within(0.2, origin: [@latitude, @longitude])
                  .select(:id, :contents, :good, :bad, :image)
                  .where(rooms_id: 1)
                  .order(created_at: :desc)

    render formats: 'json', status: :ok
  end

  # 部屋へのアクセス, 投稿権限と必要なパラメータがあるか調べる
  def judge_access_post
    if params[:latitude].nil? || params[:longitude].nil? || params[:id].nil?
      render formats: 'json', status: :not_found
    end

    @rooms_id = params[:id].to_i
    @latitude = params[:latitude].to_f
    @longitude = params[:longitude].to_f

    @flag = survey_rooms(@rooms_id, @latitude, @longitude)
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
    if rooms_id == 1 || write_flag == true
      0
    elsif access_flag == true
      1
    else
      2
    end
  end

  # dbにいれる用のパラメータを作成する
  def create_post_info(post_info)
    post_info[:latitude] = @latitude
    post_info[:longitude] = @longitude
    post_info[:rooms_id] = @rooms_id
    imgur = Imgur.new
    room_info[:image] = imgur.upload(room_info[:image])

    post_info
  end

  def post_params
    params.require(:post)
          .permit(
            :contents,
            :rooms_id,
            :latitude,
            :logitude,
            :image
          )
  end
end

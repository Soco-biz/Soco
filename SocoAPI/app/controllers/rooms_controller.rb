class RoomsController < ApplicationController
  before_action :take_location, only: [:index, :create]

  """
  @parameter: ?latitude=float&logitude=float
  """
  # ルームを取得する
  def index
    # @loungeはまだ緯度経度を取得していない
    @lounge = Post.within(0.2, origin: [@latitude, @longitude])
                  .select(:id, :contents, :good, :bad, :image, :created_at)
                  .where(rooms_id: 1)
                  .order(id: :desc)
    @small_room = Room.within(0.2, origin: [@latitude, @longitude])
                      .select(:id, :name, :image, :description, :created_at)
                      .order(id: :desc)
    @middle_room = Room.within(1.0, origin: [@latitude, @longitude])
                      .select(:id, :name, :image, :description, :created_at)
                      .order(id: :desc)
    @large_room = Room.within(3.0, origin: [@latitude, @longitude])
                      .select(:id, :name, :image, :description, :created_at)
                      .order(id: :desc)

    render formats: 'json', status: :ok
  end

  """
  @parameter: ?latitude=float&logitude=float
  content-type: application/x-www-form-urlencoded
  -d room[name]=room_name
  """
  # ルーム作成を行う
  def create
    room_info = Room.new(room_params)
    @post_room = create_room_info(room_info)

    # 半径200m以内に同じ名前の部屋があるか
    flag = Room.within(0.2, origin: [@latitude, @longitude])
               .where(name: @post_room[:name])
               .exists?

    if flag # 部屋があったら作らない
      render formats: 'json', status: :not_acceptable
    else # 部屋がなかったら作成許可
      if @post_room.save
        render formats: 'json', status: :created
      else
        render formats: 'json', status: :unprocessable_entity
      end
    end
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

  # dbにいれる用のパラメータを作成する
  def create_room_info(room_info)
    room_info[:latitude] = @latitude
    room_info[:longitude] = @longitude

    room_info
  end

  def room_params
    params.require(:room).permit(:name, :latitude, :logitude, :image, :description)
  end
end

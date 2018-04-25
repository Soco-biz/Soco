class PostsController < ApplicationController
  """
  @parameter: id=integer
  """
  # room内の投稿を取得する
  def index
    @room_posts = Room.find_by(id: params[:id])
                      .order(created_at: :desc)

  def post_params
    params.require(:post).permit(:contents, :good, :bad)
  end
end

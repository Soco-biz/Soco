require 'test_helper'

class SocoPostsControllerTest < ActionDispatch::IntegrationTest
  test 'indexの動作が成功する想定' do
    get '/soco_posts/index.json?latitude=1.5&longitude=1.5'
    assert_response :success, '投稿を取得できませんでした'
  end
end

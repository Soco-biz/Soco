require 'test_helper'

class SocoPostsControllerTest < ActionDispatch::IntegrationTest
  test 'indexの動作が成功する想定' do
    get '/soco_posts/index.json?latitude=1.5&longitude=1.5'
    assert_response :success, 'テストに失敗しました.投稿を取得できませんでした'
  end

  test 'indexの動作が位置情報不足で失敗する想定' do
    get '/soco_posts/index.json?latitude=&longitude='
    assert_response :not_found, 'テストに失敗しました.投稿を取得しました'
  end
end
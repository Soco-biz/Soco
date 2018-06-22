require 'test_helper'

class SocoPostsControllerTest < ActionDispatch::IntegrationTest
  test 'indexの動作が位置情報にそった投稿・返信数も含めて成功する想定' do
    get '/soco_posts/index.json?latitude=1.5&longitude=1.5'

    assert_response :success, 'テストに失敗しました.投稿を取得できませんでした'
    assert_equal 2, assigns(:lounge).length, 'テストに失敗しました.投稿数が違います'
    assert_equal 1, assigns(:to_reply).length, 'テストに失敗しました.返信数が違います'
  end

  test 'indexの動作が位置情報不足で失敗する想定' do
    get '/soco_posts/index.json?latitude=&longitude='
    assert_response :not_found, 'テストに失敗しました.投稿を取得しました'
  end

  test 'create処理で複数含めてタグがキチンと生成された想定' do
    post '/soco_posts/create.json?latitude=1.5&longitude=1.5',
    params: {
      'soco_post[contents]': '成功想定です',
      'soco_post[tag]': 'テストタグ1, テストタグ2'
    },
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    }
    json = JSON.parse(response.body)['posts']['tag']
    first_tag = json[0]['name']
    second_tag = json[1]['name']

    assert_equal 'テストタグ1', first_tag, 'テストに失敗しました.タグが取得できません'
    assert_equal 'テストタグ2', second_tag, 'テストに失敗しました.タグが取得できません'
  end

  test 'favoriteの動作が成功する想定' do
    post '/soco_posts/favorite.json?latitude=1.5&longitude=1.5',
    params: {
      'soco_post[id]': 1,
      'soco_post[good]': 0
    },
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    }

    assert_response :accepted, 'テストに失敗しました.いいねができません'
  end

  test 'favoriteの動作が投稿が位置情報の外にあって失敗する想定' do
    post '/soco_posts/favorite.json?latitude=10.0&longitude=10.0',
    params: {
      'soco_post[id]': 1,
      'soco_post[good]': 0
    },
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    }

    assert_response :not_acceptable, 'テストに失敗しました.いいね先の投稿が範囲外です'
  end
end
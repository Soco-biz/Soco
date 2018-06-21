require 'test_helper'

class SocoPostTest < ActiveSupport::TestCase
  test '投稿が成功する想定' do
    posts = SocoPost.new({
      contents: '成功想定です',
      latitude: 1.5,
      longitude: 1.5
    })
    assert posts.save, '保存できませんでした'
  end

  test 'latitudeとlongitudeがnilで投稿が失敗する想定' do
    posts = SocoPost.new({
      contents: '失敗する想定です',
      latitude: nil,
      longitude: nil
    })
    assert_not posts.save, '保存しました'
  end

  test 'latitudeが0で投稿が失敗する想定' do
    posts = SocoPost.new({
      contents: '失敗する想定です',
      latitude: 0,
      longitude: 1.5
    })
    assert_not posts.save, '保存しました'
  end

  test 'longitudeが0で投稿が失敗する想定' do
    posts = SocoPost.new({
      contents: '失敗する想定です',
      latitude: 1.5,
      longitude: 0
    })
    assert_not posts.save, '保存しました'
  end

  test 'contentsが1未満で投稿が失敗する想定' do
    posts = SocoPost.new({
      contents: '',
      latitude: 1.5,
      longitude: 1.5
    })
    assert_not posts.save, '保存しました'
  end

  test 'contentsが140より上で投稿が失敗する想定' do
    posts = SocoPost.new({
      contents: 'hogehogehogehogehogehogehogehogehogehogehogehogehogehogehoge
      hogehogehogehogehogehogehogehogehogehogehogehogehogehogehogehogehogehoge
      hogehogeh',
      latitude: 1.5,
      longitude: 1.5
    })
    assert_not posts.save, '保存しました'
  end
end

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

  test '投稿が失敗する想定' do
    # ここはmodelにvalidationを書いてから記述する
    posts = SocoPost.new({
      contents: '失敗する想定です',
      latitude: 1.5,
      longitude: 1.5
    })
    assert posts.save, '保存できませんでした'
end

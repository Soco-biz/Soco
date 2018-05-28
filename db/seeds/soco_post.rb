10.times do |i|
  num = i+1

  if num == 2
    # 1番目にリプライを送る
    SocoPost.create(
      id: num,
      contents: '1へのリプライです',
      reply: 1,
      latitude: 35.641927,
      longitude: 139.408568
    )
  elsif num == 3
    # first_tag追加
    SocoPost.create(
      id: num,
      contents: 'first_tagまでです',
      first_tag_id: 1,
      latitude: 35.641927,
      longitude: 139.408568
    )
  elsif num == 4
    # second_tag追加
    SocoPost.create(
      id: num,
      contents: 'second_tagまでです',
      first_tag_id: 1,
      second_tag_id: 2,
      latitude: 35.641927,
      longitude: 139.408568
    )
  elsif num == 5
    # third_tag追加
    SocoPost.create(
      id: num,
      contents: 'third_tagまでです',
      first_tag_id: 1,
      second_tag_id: 2,
      third_tag_id: 3,
      latitude: 35.641927,
      longitude: 139.408568
    )
  elsif num == 6
    # 連続リプライ確認
    SocoPost.create(
      id: num,
      contents: '2へのリプライです',
      reply: 2,
      good: 0,
      latitude: 35.641927,
      longitude: 139.408568
    )
  elsif num == 7
    SocoPost.create(
      id: num,
      contents: '緯度経度別のデータ',
      latitude: -1,
      longitude: -1
    )
  else
    # normal処理
    SocoPost.create(
      id: num,
      contents: 'テストデータです',
      latitude: 35.641927,
      longitude: 139.408568
    )
  end
end


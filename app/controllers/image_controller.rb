def index
    @messages = Post.all
    # ここから追記
    respond_to do |format| 
      format.html # html形式でアクセスがあった場合は特に何もなし(@messages = Message.allして終わり）
      format.json { @new_message = Post.where('id > ?', params[:content][:id]) } # json形式でアクセスがあった場合は、params[:message][:id]よりも大きいidがないかMessageから検索して、@new_messageに代入する
    end
  end
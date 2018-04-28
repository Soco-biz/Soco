class Imgur

  URL = 'https://api.imgur.com/3/image'

  def initialize(client_id)
    @client_id = '917c103fc588ceb'
  end

  def upload(file_path)
    auth_header = { 'Authorization' => 'Client-ID ' + @client_id }
    execute(auth_header, file_path)
  end

  private
  def execute(auth_header, file_path)
    http_client = HTTPClient.new
    File.open(file_path) do |file|
      body = { 'image' => file }
      @res = http_client.post(URI.parse(URL), body, auth_header)
    end

    result_hash = JSON.load(@res.body)
    result_hash['data']['link']
  end
end

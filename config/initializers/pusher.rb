require 'pusher'

Pusher.app_id = ENV['PRO_PUSHER_ID']
Pusher.key = ENV['PRO_PUSHER_KEY']
Pusher.secret = ENV['PRO_PUSHER_SECRET']
Pusher.cluster = 'ap1'
Pusher.logger = Rails.logger
Pusher.encrypted = true
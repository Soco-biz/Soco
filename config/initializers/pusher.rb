require 'pusher'

Pusher.app_id = ENV['DEV_PUSHER_ID']
Pusher.key = ENV['DEV_PUSHER_KEY']
Pusher.secret = ENV['DEV_PUSHER_SECRET']
Pusher.cluster = 'mt1'
Pusher.logger = Rails.logger
Pusher.encrypted = true
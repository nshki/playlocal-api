Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_API_KEY'], ENV['TWITTER_API_SECRET'], {
    secure_image_url: 'true',
    image_size: 'original',
  }
  provider :discord, ENV['DISCORD_API_KEY'], ENV['DISCORD_API_SECRET']
end

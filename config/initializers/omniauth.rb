Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_API_KEY'], ENV['TWITTER_API_SECRET'], {
    secure_image_url: 'true',
    image_size: 'original',
  }
  provider :discord, ENV['DISCORD_API_KEY'], ENV['DISCORD_API_SECRET']
  provider :google_oauth2, ENV['GOOGLE_API_KEY'], ENV['GOOGLE_API_SECRET'], {
    name: 'google',
    image_aspect_ratio: 'square',
  }
end

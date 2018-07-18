User.destroy_all

100.times do
  fake_user = Faker::Twitter.unique.user
  provider = ['twitter', 'discord'].sample
  providers = [true, false].sample ? ['twitter', 'discord'] : [provider]

  user = User.find_or_create_by(
    username: fake_user[:name],
    avatar_platform: providers.sample,
  )

  # Randomly generate just one or both identities.
  providers.each do |p|
    username = fake_user[:screen_name]
    username += '#123' if p === 'discord'
    user.identities.create(
      uid: fake_user[:id_str],
      provider: p,
      username: username,
      image_url: fake_user[:profile_image_url],
    )
  end

  user.play_signal.update(
    message: fake_user[:description],
    lat: Faker::Address.latitude,
    lng: Faker::Address.longitude,
    published: true,
    end_time: rand(Time.now..3.hours.from_now),
  )

  p "Created #{user.username}"
end

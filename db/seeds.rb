50.times do
  provider = ['twitter', 'discord'].sample
  fake_user = Faker::Twitter.unique.user
  provider_username = fake_user[:screen_name]
  provider_username += '#123' if provider == 'discord'

  user = User.find_or_create_by(
    username: fake_user[:name],
    avatar_platform: provider,
  )
  user.identities.create(
    uid: fake_user[:id_str],
    provider: provider,
    username: fake_user[:screen_name],
    image_url: fake_user[:profile_image_url],
  )
  user.play_signal.update(
    message: fake_user[:description],
    lat: Faker::Address.latitude,
    lng: Faker::Address.longitude,
    published: true,
    end_time: DateTime.current + 50.years,
  )

  p "Created #{user.username}"
end

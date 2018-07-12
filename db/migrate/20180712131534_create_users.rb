class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username, unique: true
      t.string :avatar_platform
      t.string :twitter_uid
      t.string :twitter_username
      t.string :twitter_image_url
      t.string :discord_uid
      t.string :discord_username
      t.string :discord_image_url

      t.timestamps

      t.index :twitter_uid, unique: true
      t.index :discord_uid, unique: true
    end
  end
end

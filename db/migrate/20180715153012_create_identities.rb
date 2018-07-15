class CreateIdentities < ActiveRecord::Migration[5.2]
  def change
    create_table :identities do |t|
      t.string :provider
      t.string :uid
      t.string :username
      t.string :image_url
      t.string :user_id

      t.timestamps

      t.index :uid
      t.index :user_id
    end

    remove_index :users, :twitter_uid
    remove_index :users, :discord_uid

    remove_column :users, :twitter_uid, :string
    remove_column :users, :twitter_username, :string
    remove_column :users, :twitter_image_url, :string
    remove_column :users, :discord_uid, :string
    remove_column :users, :discord_username, :string
    remove_column :users, :discord_image_url, :string
  end
end

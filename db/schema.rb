# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_07_12_131534) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "avatar_platform"
    t.string "twitter_uid"
    t.string "twitter_username"
    t.string "twitter_image_url"
    t.string "discord_uid"
    t.string "discord_username"
    t.string "discord_image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discord_uid"], name: "index_users_on_discord_uid", unique: true
    t.index ["twitter_uid"], name: "index_users_on_twitter_uid", unique: true
  end

end

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

ActiveRecord::Schema.define(version: 20170508011846) do

  create_table "issues", force: :cascade do |t|
    t.integer "number"
    t.string "title"
    t.string "answer"
    t.datetime "closed_at"
    t.integer "repos_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["repos_id"], name: "index_issues_on_repos_id"
  end

  create_table "repos", force: :cascade do |t|
    t.string "name"
    t.string "full_name"
    t.string "owner_name"
    t.integer "owner_id"
    t.string "avatar_url"
    t.datetime "last_checked"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stars", force: :cascade do |t|
    t.integer "users_id"
    t.integer "repos_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["repos_id"], name: "index_stars_on_repos_id"
    t.index ["users_id"], name: "index_stars_on_users_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "name"
    t.string "avatar_url"
    t.string "email"
    t.string "provider", null: false
    t.string "uid", null: false
    t.string "oauth_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end

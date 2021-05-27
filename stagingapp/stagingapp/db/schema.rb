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

ActiveRecord::Schema.define(version: 20180623074915) do

  create_table "plans", force: :cascade do |t|
    t.string "stripe_id", null: false
    t.string "name", null: false
    t.decimal "display_price", null: false
    t.integer "maxredirect", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscribers", force: :cascade do |t|
    t.string "stripe_customer_id", null: false
    t.datetime "subscribed_at", null: false
    t.datetime "subscription_expires_at", null: false
    t.integer "plan_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_subscribers_on_plan_id"
    t.index ["plan_id"], name: "plans_for_subsribers"
    t.index ["subscribed_at"], name: "subscribed_at_for_subscribers"
    t.index ["subscription_expires_at"], name: "expiring_subscritions_on_subscribers"
    t.index ["user_id"], name: "index_subscribers_on_user_id", unique: true
  end

  create_table "urls", force: :cascade do |t|
    t.text "source"
    t.text "destination"
    t.integer "user_id"
    t.boolean "active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source"], name: "index_urls_on_source", unique: true
    t.index ["user_id", "destination"], name: "index_urls_on_user_id_and_destination"
    t.index ["user_id", "updated_at"], name: "index_urls_on_user_id_and_updated_at"
    t.index ["user_id"], name: "index_urls_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2026_02_25_173635) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "otps", force: :cascade do |t|
    t.uuid "uuid", null: false
    t.string "identifier", null: false
    t.string "channel"
    t.string "context", null: false
    t.string "otp_digest", null: false
    t.datetime "expires_at"
    t.datetime "last_sent_at"
    t.datetime "blocked_at"
    t.integer "attempts", default: 0
    t.boolean "verified", default: false
    t.jsonb "metadata"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["expires_at"], name: "index_otps_on_expires_at"
    t.index ["identifier", "context"], name: "index_otps_on_identifier_and_context"
    t.index ["uuid"], name: "index_otps_on_uuid", unique: true
  end

end

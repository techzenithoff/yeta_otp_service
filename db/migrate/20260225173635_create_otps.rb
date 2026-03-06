class CreateOtps < ActiveRecord::Migration[6.1]
    def change
        create_table :otps do |t|

        t.uuid :uuid, null: false

        t.string :identifier, null: false
        t.string :channel
        t.string :context, null: false

        t.string :otp_digest, null: false

        t.datetime :expires_at
        t.datetime :last_sent_at
        t.datetime :blocked_at

        t.integer :attempts, default: 0

        t.boolean :verified, default: false

        t.jsonb :metadata

        t.timestamps
        end

        add_index :otps, :uuid, unique: true
        add_index :otps, [:identifier, :context]
        add_index :otps, :expires_at
    end
end
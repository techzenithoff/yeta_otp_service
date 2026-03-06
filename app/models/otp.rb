class Otp < ApplicationRecord

    # Include shared utils.
    include SharedUtils::Generate

    before_create :generate_uuid

    validates  :identifier, :channel, :context, presence: true
end

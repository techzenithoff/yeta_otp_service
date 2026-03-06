module Services
    module Otp
        class GeneratorOld
            def self.generate!(params)
                code = SecureRandom.random_number(10**6).to_s.rjust(6,'0')
                Otp.create!(
                    identifier: params[:identifier],
                    channel: params[:channel],
                    context: params[:context],
                    otp_digest: BCrypt::Password.create(code),
                    expires_at: 5.minutes.from_now
                )
            end
        end
    end
end

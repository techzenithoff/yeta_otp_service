module OtpService
    class Generator
        #OTP_EXPIRATION = 5.minutes
        OTP_EXPIRATION = 1.minutes
        RESEND_INTERVAL = 30.seconds

        def self.generate!(params)
            identifier = params[:identifier]
            context    = params[:context]
            channel    = params[:channel]
            metadata   = params[:metadata] || {}

            otp = ::Otp.where(identifier: identifier, context: context, verified: false).where("expires_at > ?", Time.current).last

            if otp.present?
                if otp.last_sent_at && otp.last_sent_at > RESEND_INTERVAL.ago
                    retry_in = (otp.last_sent_at + RESEND_INTERVAL - Time.current).ceil
                    # Retour au lieu de lever une exception
                    return { resend: false, message: "Veuillez patienter avant de redemander un code.", retry_in: retry_in}
                end

                # On regenere un nouveau code pour le resend
                code = SecureRandom.random_number(10**6).to_s.rjust(6, '0')
                otp.update!(otp_digest: BCrypt::Password.create(code), last_sent_at: Time.current)

                return { otp: otp, code: code, resend: true }
            end

            # Création d'un nouvel OTP
            code = SecureRandom.random_number(10**6).to_s.rjust(6, '0')
            otp = ::Otp.create!(
                identifier: identifier,
                channel: channel,
                context: context,
                otp_digest: BCrypt::Password.create(code),
                expires_at: OTP_EXPIRATION.from_now,
                last_sent_at: Time.current,
                metadata: metadata
            )

            { otp: otp, code: code, resend: false }
        end
    end
end
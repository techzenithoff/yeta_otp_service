module OtpService
    class Verifier
        MAX_ATTEMPTS = 5

        def self.verify!(params)
            otp = ::Otp.where(identifier: params[:identifier], context: params[:context], verified: false).order(expires_at: :desc).first

            # OTP introuvable ou expiré
            unless otp && otp.expires_at > Time.current
                return {success: false, code: :expired, message: "OTP introuvable ou expiré"}
            end

            # OTP bloqué
            if otp.blocked_at.present?
                return {success: false, code: :blocked, message: "OTP bloqué"}
            end

            # OTP valide
            if BCrypt::Password.new(otp.otp_digest) == params[:otp]
                otp.update!(verified: true)

                return {success: true, code: :ok, message: "OTP vérifié avec succès"}
            end

            # OTP invalide
            otp.increment!(:attempts)
            otp.update!(blocked_at: Time.current) if otp.attempts >= MAX_ATTEMPTS

            { success: false, code: :invalid, message: "OTP invalide" }
        end
    end
end
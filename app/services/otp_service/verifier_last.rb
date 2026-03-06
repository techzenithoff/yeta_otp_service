
module OtpService
    class VerifierLast
        MAX_ATTEMPTS = 5

        def self.verify!(params)
            otp = ::Otp.where(identifier: params[:identifier], context: params[:context], verified: false).order(expires_at: :desc).first

            #raise "OTP introuvable ou expiré" unless otp && otp.expires_at > Time.current
            return  {status: 400, message: "OTP introuvable ou expiré"} unless otp && otp.expires_at > Time.current
            #raise "OTP bloqué" if otp.blocked_at.present?
            return {status: 400, message: "OTP bloqué"} if otp.blocked_at.present?

            if BCrypt::Password.new(otp.otp_digest) == params[:otp]
                otp.update!(verified: true)
                { verified: true, otp: otp }
            else
                otp.increment!(:attempts)
                otp.update!(blocked_at: Time.current) if otp.attempts >= MAX_ATTEMPTS
                return {message: "OTP invalide"}
            end
        end

        
    end
end

#module Services
    module OtpService
        class VerifierOld
            def self.verify!(params)

                otp = Otp.where(identifier: params[:identifier],context: params[:context], verified: false).order(expires_at: :desc).first

                raise "Code OTP introuvable ou expiré" unless otp && otp.expires_at > Time.current

                if BCrypt::Password.new(otp.otp_digest) == params[:code]
                    otp.update!(verified: true)
                else
                    otp.increment!(:attempts)
                    raise "Code OTP invalide"
                end
            end
        end
    end
#end

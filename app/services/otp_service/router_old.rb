module Services
    module Otp
        class RouterOld
            def self.send_otp(otp)
                message = "Your OTP code"
                
                case otp.channel
                when 'whatsapp'
                    Services::Channels::WhatsappService.send_otp(otp.identifier, message)
                when 'sms'
                Services::Channels::SmsService.send_otp(otp.identifier, message)
                when 'email'
                    Services::Channels::EmailService.send_otp(otp.identifier, message)
                end
            end
        end
    end
end

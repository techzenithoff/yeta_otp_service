#module Services
    module Channels
        class WhatsappService
            def self.send_otp(to, message)
                puts "[WHATSAPP MOCK] #{to}: #{message}"
            end
        end
    end
#end

#module Services
    module Channels
        class EmailService
            def self.send_otp(to, message)
                puts "[EMAIL MOCK] #{to}: #{message}"
            end
        end
    end
#end

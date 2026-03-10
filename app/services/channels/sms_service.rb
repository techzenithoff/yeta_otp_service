#module Services
    module Channels
        class SmsService
            def self.send_otp(to, message)
                puts "[SMS MOCK] #{to}: #{message}"
            end
        end
    end
#end

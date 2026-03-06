module OtpService
  class Router
    FALLBACK_CHANNELS = {
      'sms' => ['email', 'whatsapp'],
      'email' => ['sms'],
      'whatsapp' => ['sms', 'email']
    }

    def self.send_otp(otp, code, context: "login", metadata: {})
      payload = {
        identifier: otp.identifier,
        channel: otp.channel,
        context: context,
        otp_code: code, # jamais nil maintenant
        uuid: otp.uuid,
        metadata: metadata
      }


      # Publish initial event
      EventPublisher.publish("otp.generated", payload)

      #Rails.logger.info("OTP event published for #{otp.identifier} via #{otp.channel}")
    end
  end
end
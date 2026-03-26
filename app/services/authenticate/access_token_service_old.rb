# frozen_string_literal: true

module Auth
  class AccessTokenServiceOld
    InvalidTokenError = Class.new(StandardError)
    ExpiredTokenError = Class.new(StandardError)

    SECRET_KEY = ENV.fetch("JWT_SECRET_KEY") { raise "JWT_SECRET_KEY non définie !" }

    ACCESS_TOKEN_EXPIRATION = Integer(ENV.fetch("ACCESS_TOKEN_EXPIRATION") { 15 })

    ALGORITHM = 'HS256'.freeze
    ISSUER    = 'user-service'.freeze
    AUDIENCE  = 'client'.freeze

    class << self
      # ===============================
      # ENCODE
      # ===============================
      def encode(payload, exp: default_expiration)
        payload = payload.dup
        payload[:exp] = exp.to_i
        payload[:iss] = ISSUER
        payload[:aud] = AUDIENCE
        payload[:jti] = SecureRandom.uuid

        JWT.encode(payload, SECRET_KEY, ALGORITHM)
      end

      # ===============================
      # DECODE
      # ===============================
      def decode(token)
        raise InvalidTokenError, "Token manquant" if token.blank?

        decoded, = JWT.decode(token, SECRET_KEY, true, decode_options)

        payload = decoded.with_indifferent_access

        validate_payload!(payload)

        payload

      rescue JWT::ExpiredSignature
        raise ExpiredTokenError, "Le token a expiré"

      rescue JWT::ImmatureSignature
        raise InvalidTokenError, "Token pas encore valide"

      rescue JWT::InvalidIssuerError
        raise InvalidTokenError, "Issuer invalide"

      rescue JWT::InvalidAudError
        raise InvalidTokenError, "Audience invalide"

      rescue JWT::DecodeError => e
        raise InvalidTokenError, e.message
      end

      private

      def decode_options
        {
          algorithm: ALGORITHM,
          verify_iss: true,
          iss: ISSUER,
          verify_aud: true,
          aud: AUDIENCE,
          leeway: 30
        }
      end

      def validate_payload!(payload)
        raise InvalidTokenError, "Payload invalide" if payload.blank?
      end

      def default_expiration
        ACCESS_TOKEN_EXPIRATION.minutes.from_now
      end
    end
  end
end
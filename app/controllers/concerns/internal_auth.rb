module InternalAuth
    extend ActiveSupport::Concern

    included do
        before_action :authenticate_service!
    end

    private

    def authenticate_service!
        token = request.headers["Authorization"]&.split(" ")&.last
        Rails.logger.info("[InternalAuth] authenticate_service! called, token present: #{token.present?}")
            Rails.logger.info("[InternalAuth] authenticate_service! called | token reçu: #{token.inspect} | token attendu: #{ENV['INTERNAL_SERVICE_TOKEN'].inspect}")

        unless token == (ENV["INTERNAL_SERVICE_TOKEN"] || "9c4e2f3a7d8b6f5e1a2c4d7e8f9b1c6a3e5d7f2a8b9c4d6e1f3a7b8c2d5e9f1")
            Rails.logger.warn("[InternalAuth] Unauthorized service attempt")
            render json: { error: "Unauthorized service" }, status: :unauthorized
        else
            Rails.logger.info("[InternalAuth] Service authorized successfully")
        end
    rescue => e
        Rails.logger.error("[InternalAuth] Error in authenticate_service!: #{e.message}")
        raise
    end
end
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

        unless token == ENV["INTERNAL_SERVICE_TOKEN"]
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
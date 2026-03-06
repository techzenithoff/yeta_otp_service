module InternalAuth
    extend ActiveSupport::Concern

    included do
        before_action :authenticate_service!
    end

    private

    def authenticate_service!
        token = request.headers["Authorization"]&.split(" ")&.last

        unless token == ENV["INTERNAL_SERVICE_TOKEN"]
        render json: { error: "Unauthorized service" }, status: :unauthorized
        end
    end
end
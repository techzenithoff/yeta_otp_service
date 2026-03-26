# frozen_string_literal: true

  class AccountServiceClient < BaseClient
    # On pointe vers l'espace "internal" du service de destination
    base_uri ENV.fetch("ACCOUNT_SERVICE_URL", "http://localhost:3000")

    # L'audience doit être le nom du service cible
    SERVICE_AUDIENCE = "user-service"

    class << self
      def audience_name
        SERVICE_AUDIENCE
      end

      # ===============================
      # GET ACCOUNT BY ID (Internal Only)
      # ===============================
      def find_account(account_id)
        # On ne passe plus de token utilisateur ici car c'est une route M2M
        Rails.logger.info("[Internal-Call] Requesting account #{account_id} from #{SERVICE_AUDIENCE}")

        # Le BaseClient injecte automatiquement le X-Internal-Service-Token
        request(:get, "/api/v1/accounts/#{account_id}")
      end
    end
  end

module InternalAuthenticate
    extend ActiveSupport::Concern

    included do
        #before_action :authenticate_service!
        # On protège toutes les actions par défaut pour ce contrôleur
        before_action :authenticate_internal_service!
    end

    private

    def authenticate_internal_service!

        # 1. Récupération du token (soit X-Internal-Service-Token, soit Authorization)
        token = request.headers['X-Internal-Service-Token'] || request.headers['Authorization']&.split(' ')&.last


        if token.blank?
            render_unauthorized("Token de service manquant")
            return
        end


        # 2. Décodage et validation via ton service RSA
        # Cette méthode lèvera une erreur si la clé n'est pas dans le catalogue
        #payload = Authenticate::InternalTokenService.decode(token, expected_audience: expected_service_name)
        payload = Authenticate::InternalTokenService.decode(token)


        # Sécurité supplémentaire : on force l'arrêt si payload est invalide
        if payload.blank?
            return render json: { error: 'Unauthorized service' }, status: :unauthorized
        end

        # Vérification de la nature du compte
        unless payload[:sub] == 'service'
            return render_unauthorized("Accès réservé aux services internes")
        end

        # 3. Optionnel : On stocke l'identité du service appelant
        @current_internal_service = payload[:iss]

    rescue Authenticate::InternalTokenService::TokenError => e
        render_unauthorized("Accès refusé : #{e.message}")
    rescue StandardError => e
        Rails.logger.error "[Auth] Erreur inattendue : #{e.message}"
        render_unauthorized("Erreur d'authentification interne")
    end



    def render_unauthorized(message)
        render json: { error: 'Unauthorized',  message: message, service: ENV['SERVICE_NAME'] }, status: :unauthorized
    end




end
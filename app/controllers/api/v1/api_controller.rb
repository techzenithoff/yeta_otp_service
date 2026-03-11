module Api::V1
  class ApiController < ApplicationController
    # Auth utilisateur par défaut
    before_action :authenticate_account!

    attr_reader :current_account_id

    private

    # Auth JWT pour comptes utilisateurs
    def authenticate_account!
      # Récupère le token depuis le header Authorization
      header = request.headers['Authorization']
      token = header.split(' ').last if header

      # Decode le token avec ton service TokenVerifier
      payload = TokenVerifierService.decode(token)

      if payload.nil?
        render json: { error: 'Unauthorized' }, status: :unauthorized
      else
        @current_account_id = payload["account_id"]
        Rails.logger.info("CURRENT ACCOUNT ID: #{current_account_id}")
      end
    end
  end
end
module Api::V1
	class ApiController < ApplicationController
		before_action :authenticate_account!

		attr_reader :current_account_id

		private

		def authenticate_account!

			token = request.headers["Authorization"]&.split(' ')&.last

			header = request.headers['Authorization']
			token = header.split(' ').last if header

			payload = TokenVerifierService.decode(token)

			if payload.nil?
				render json: { error: 'Unauthorized' }, status: :unauthorized
			else

				
				@current_account_id = payload["account_id"]

				puts "CURRENT ACCOUNT ID: #{current_account_id}"
			end
		end
	end
end
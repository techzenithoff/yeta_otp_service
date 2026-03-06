module Api
    module V1
        class OtpsController < ApplicationController

            include InternalAuth
            
        rescue_from StandardError, with: :handle_error

        def create
            result = ::OtpService::Generator.generate!(otp_params.merge(metadata: request_metadata))

            if result[:resend] == false && result[:retry_in]
                return render json: { message: result[:message], retry_in: result[:retry_in] }, status: :too_many_requests
            end

            OtpService::Router.send_otp(result[:otp], result[:code], context: otp_params[:context], metadata: request_metadata)
            render json: { status: 'sent', resend: result[:resend] }
        end

        def verify
            response = ::OtpService::Verifier.verify!(verify_params)

            puts "RESPONSE FROM VERIFIER IN CONTROLLER: #{response.inspect}"


            case response[:code]
            when :ok
                render json: {sucess: response[:success], code: response[:code],  message: response[:message] }, status: :ok

            when :expired
                render json: {sucess: response[:success], code: response[:code],  message: response[:message] }, status: :not_found

            when :blocked
                render json: { sucess: response[:success], code: response[:code],  message: response[:message] }, status: :forbidden

            when :invalid
                render json: { sucess: response[:success], code: response[:code],  message: response[:message] }, status: :unauthorized

            else
                render json: { message: "Erreur interne OTP" }, status: :internal_server_error
            end

            #render json: { status: 'verified' }
        end

        private

        def otp_params
            #params.permit(:identifier, :channel, :context)
            params.require(:otp).permit(:identifier, :channel, :context)
        end

        def verify_params
            params.permit(:identifier, :context, :otp)
        end

        def request_metadata
            { ip: request.remote_ip, user_agent: request.user_agent }
        end

        def handle_error(e)
            Rails.logger.error("OTP Service Error: #{e.class} - #{e.message}")
            Rails.logger.error(e.backtrace.join("\n"))
            #render json: { error: e.message }, status: 400
            # Retourner l'erreur dans le corps de la réponse
            render json: { error: e.message }, status: e.is_a?(RuntimeError) ? 429 : 400
        end
        end
    end
end
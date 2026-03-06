module Api
    module V1
        class OtpsOldController < ApplicationController

            def create
                otp = Services::Otp::Generator.generate!(otp_params)
                Services::Otp::Router.send_otp(otp)
                render json: { status: 'sent' }
            end

            def verify
                Services::Otp::Verifier.verify!(verify_params)
                render json: { status: 'verified' }
            end

            private

            def otp_params
                params.permit(:identifier, :channel, :context)
            end

            def verify_params
                params.permit(:identifier, :context, :code)
            end

        end
    end
end

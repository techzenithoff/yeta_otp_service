
module Errors
    module Auth
        module Errors
            class TokenExpired < StandardError; end
            class TokenInvalid < StandardError; end
            class SessionNotFound < StandardError; end
            class SessionExpired < StandardError; end
            class DeviceBlocked < StandardError; end
        end
    end
end

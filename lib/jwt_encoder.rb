class JWTEncoder
    class << self
        def encode(payload, expiration = nil)
            expiration ||= Rails.application.secrets.jwt_expiration_hours
            
            payload['exp'] = expiration.to_i.hours.from_now.to_i
            
            JWT.encode(payload, Rails.application.secrets.jwt_secret)
        end
        
        def decode(token)
            begin
                decoded_token = JWT.decode(token, Rails.application.secrets.jwt_secret)
                decoded_token.first
            rescue
                nil
            end
        end
    end
end
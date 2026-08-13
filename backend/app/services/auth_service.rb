require "jwt"

class AuthService
  SECRET_KEY = Rails.application.secret_key_base || "aratel_vvip_jwt_secret_key_2026"
  ALGORITHM = "HS256"
  EXPIRATION_HOURS = 24

  def self.encode(payload, exp = EXPIRATION_HOURS.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY, ALGORITHM)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY, true, { algorithm: ALGORITHM })[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError, JWT::ExpiredSignature => e
    Rails.logger.warn("[AuthService] JWT Token Decoding Failed: #{e.message}")
    nil
  end
end

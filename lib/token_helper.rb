module TokenHelper
  SECRET_KEY = Rails.application.credentials.secret_key_base

  def encode(payload)
    payload[:expiry] = (Time.now + 24.hours).iso8601()
    token = JWT.encode(payload, SECRET_KEY)
  end

  def decode_token(payload)
    decoded_token = JWT.decode(payload, SECRET_KEY, true).first
  end
end
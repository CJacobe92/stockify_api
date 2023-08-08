module TokenHelper

  def decode_token(payload)
    decoded_token = JWT.decode(payload, secret_key, true).first
  end

  def encode_token(payload)
    payload[:expiry] = (Time.now + 24.hours).iso8601
    token = JWT.encode(payload, secret_key)
  end

  def encode_activation_token(payload)
    payload[:expiry] = (Time.now + 1.hour).iso8601
    token = JWT.encode(payload, secret_key)
  end

  
  def encode_reset_token(payload)
    payload[:expiry] = (Time.now + 15.minutes).iso8601
    token = JWT.encode(payload, secret_key)
  end

  def secret_key
    Rails.application.credentials.secret_key_base
  end

end
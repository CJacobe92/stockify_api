require 'rqrcode'

module OTPGenerator
  def generate_otp_qr_code(user)
    issuer = 'stockify'
    label = "#{issuer}:#{user.email}"
    otp_url = ROTP::TOTP.new(user.otp_secret_key, issuer: issuer).provisioning_uri(label)
    qrcode = RQRCode::QRCode.new(otp_url)
    qrcode.as_svg(module_size: 4)
  end
end
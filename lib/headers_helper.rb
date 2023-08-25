module HeadersHelper
  def response_headers(account, token)
    response.headers['Uid'] = account.id
    response.headers['Authorization'] = "Bearer #{token}"
    response.headers['Client'] = 'stockify'
    response.headers['Activated'] = account.activated
    response.headers['Otp_enabled'] = account.otp_enabled
    response.headers['Otp_required'] = account.otp_required
   end
end
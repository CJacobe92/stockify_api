module HeadersHelper
  def response_headers(account, token)
    response.headers['uid'] = account.id
    response.headers['authorization'] = "Bearer #{token}"
    response.headers['client'] = 'stockify'
    response.headers['activated'] = account.activated
    response.headers['otp_enabled'] = account.otp_enabled
    response.headers['otp_required'] = account.otp_required
    response.headers['user_type'] = account.is_a?(Admin) ? 'Admin' : 'User'
   end
end
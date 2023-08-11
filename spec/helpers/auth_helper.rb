require './lib/token_helper'

module AuthHelper
  include TokenHelper

  def header(payload)
    account = payload[:account]
    user_id = payload[:id]

    if account == 'user'
      user = User.find(user_id)
      user&.authenticate('password')
      token = encode_token(id: user_id)
      user.update(token: token)
      return "Bearer #{token}"
      
    elsif account == 'admin'
      admin = Admin.find(user_id)
      admin&.authenticate('password')
      token = encode_token(id: user_id)
      admin.update(token: token)
      return "Bearer #{token}"
    end
  end
end

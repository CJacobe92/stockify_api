require "./lib/token_helper"

module AuthHelper
  include TokenHelper

  def header(payload)
    if user && user.authenticate('password')
      token = encode_token(payload)
      user.update(token: token)
      return "Bearer #{token}"
    end
  end
end
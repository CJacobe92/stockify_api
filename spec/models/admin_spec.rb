require 'rails_helper'

RSpec.describe Admin, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:firstname) }
    it { is_expected.to validate_presence_of(:lastname) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_presence_of(:password_confirmation) }
  end

  describe 'email format validations' do
    it 'validates has a valid email address' do
      valid_email = 'john.doe@email.com'
      expect(valid_email).to match(URI::MailTo::EMAIL_REGEXP)
    end

    it 'invalidates an invalid email address' do
      invalid_email = 'invalid_email'
      expect(invalid_email).not_to match(URI::MailTo::EMAIL_REGEXP)
    end
  end
end

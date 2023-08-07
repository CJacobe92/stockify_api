require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    pending 'In progress models to use'
  end

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

  describe 'password_digest format validations' do
    let!(:user){FactoryBot.create(:user)}

    it 'returns true when password is correct' do
      expect(user.authenticate('password')).to be_truthy
    end

    it 'returns false when password is incorrect' do
      expect(user.authenticate('wrong_password')).to be_falsey
    end
  end

end

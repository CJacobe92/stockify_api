require 'rails_helper'

RSpec.describe Account, type: :model do
  describe 'associations' do
    it { is_expected.to have_one(:portfolio).dependent(:destroy) }
    it { is_expected.to belong_to(:user) }
  end

  # describe 'validations' do
  # end
end 

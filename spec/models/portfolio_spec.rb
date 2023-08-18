require 'rails_helper'

RSpec.describe Portfolio, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:stock) }
    it { is_expected.to belong_to(:account) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:shares) }
    it { is_expected.to validate_presence_of(:purchase_price) }
    it { is_expected.to validate_presence_of(:unrealized_pl) }
    it { is_expected.to validate_presence_of(:equity) }
  end
end

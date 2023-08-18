require 'rails_helper'

RSpec.describe StockPrice, type: :model do
  describe 'association' do
    it { is_expected.to belong_to(:stock) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:symbol) }
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_presence_of(:percent_change) }
    it { is_expected.to validate_presence_of(:volume) }
    it { is_expected.to validate_presence_of(:currency) }
  end

end

require 'rails_helper'

RSpec.describe Booking, type: :model do
  describe '#validations' do
    it { is_expected.to validate_presence_of(:check_in) }
    it { is_expected.to validate_presence_of(:traveler_name) }
    it { is_expected.to validate_presence_of(:check_out) }
  end
end

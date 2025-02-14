require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe '#validations' do
    it { is_expected.to validate_presence_of(:pdf) }
    it { is_expected.to validate_content_type_of(:pdf).allowing('application/pdf') }
    it { is_expected.to validate_size_of(:pdf).greater_than(1.kilobyte) }
  end
end

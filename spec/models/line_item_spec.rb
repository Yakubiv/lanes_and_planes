require 'rails_helper'

RSpec.describe LineItem, type: :model do
  describe '#validations' do
    it { is_expected.to validate_presence_of(:quantity) }
    it { is_expected.to validate_presence_of(:unit_price) }
    it { is_expected.to validate_presence_of(:start_date) }
    it { is_expected.to validate_presence_of(:end_date) }

    context 'end_date_after_start_date' do
      it 'is valid when end_date is after start_date' do
        line_item = build(:line_item, invoice: build(:invoice), start_date: Date.today, end_date: Date.tomorrow)

        expect(line_item).to be_valid
      end

      it 'is invalid when end_date is before start_date' do
        line_item = build(:line_item, start_date: Date.tomorrow, end_date: Date.today)

        expect(line_item).not_to be_valid
        expect(line_item.errors[:end_date]).to include('must be after the start date')
      end
    end
  end
end

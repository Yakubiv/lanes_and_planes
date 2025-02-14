require 'rails_helper'

RSpec.describe Invoices::ConnectBookingForm do
  let(:booking_id) { '12345678' }
  let(:invoice) { create(:invoice) }

  let(:params) do
    { booking_id:, invoice: }
  end

  describe '#submit' do
    context 'when booking id is not present' do
      let(:booking_id) { nil }

      it 'responds with an error' do
        form = described_class.new(params)
        form.submit

        expect(form.errors[:booking_id]).to include("can't be blank")
      end
    end

    context 'when booking id is present but not valid' do
      let(:booking_id) { 'not' }

      it 'responds with an error' do
        form = described_class.new(params)
        form.submit

        expect(form.errors[:booking_id]).to include("can't be found")
      end
    end

    context 'when booking id is present' do
      it 'returns the booking' do
        form = described_class.new(params)
        form.submit

        expect(form.invoice.booking).to be_present
        expect(form.invoice.booking.booking_id).to eq(booking_id)
        expect(form.invoice.booking.hotel_name).to eq('Test Booking Hotel USA')
        expect(form.invoice.booking.traveler_name).to eq('Test Name')
      end
    end
  end
end
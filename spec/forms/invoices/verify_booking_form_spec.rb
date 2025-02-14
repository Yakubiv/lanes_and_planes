require 'rails_helper'

RSpec.describe Invoices::VerifyBookingForm do
  let(:invoice) { create(:invoice) }
  let(:booking_verified) { true }
  let(:receiving_company_verified) { true }
  let(:same_country) { true }


  let(:params) do
    { invoice: invoice,
      booking_verified:,
      receiving_company_verified:,
      same_country: }
  end

  describe '#submit' do
    context 'when all fields are verified' do
      it 'updates invoice with the correct data' do
        form = described_class.new(params)
        form.submit

        expect(form.invoice.booking_verified).to eq(booking_verified)
        expect(form.invoice.receiving_company_verified).to eq(receiving_company_verified)
        expect(form.invoice.same_country).to eq(same_country)
      end
    end

    context 'when fields are not verified' do
      let(:booking_verified) { false }
      let(:receiving_company_verified) { false }
      let(:same_country) { true }

      it 'responds with an error' do
        form = described_class.new(params)
        form.submit

        expect(form.errors[:booking_verified]).to include("must be accepted")
        expect(form.errors[:receiving_company_verified]).to include("must be accepted")
      end
    end

    context 'when invoice is missing' do
      let(:invoice) { nil }

      it 'responds with an error' do
        form = described_class.new(params)
        form.submit

        expect(form.errors[:invoice]).to include("can't be blank")
      end
    end
  end
end
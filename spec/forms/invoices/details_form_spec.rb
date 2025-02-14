
require 'rails_helper'

RSpec.describe Invoices::DetailsForm do
  let(:booking) { create(:booking) }
  let(:invoice) { create(:invoice, booking:) }
  let(:params) do
  {
      vat_id: '123456789',
      country: 'Germany',
      company_name: 'Test Company',
      invoice_date: '2023-10-01',
      invoice_number: 'INV-001',
      street: 'Test Street',
      street_number: '123',
      postal_code: '12345',
      city: 'Test City',
      invoice_has_word_invoice: true,
      line_items_attributes: {
        "0" => {
          id: nil,
          traveler_name: 'John Doe',
          start_date: '2023-10-01',
          end_date: '2023-10-05',
          description: 'Hotel stay',
          category: 'hotel',
          quantity: 1,
          unit_price: '100.00',
          _destroy: false
        }
      }
    }
  end

  describe '#submit' do
    context 'with valid parameters' do
      it 'permits the parameters and updates the invoice' do
        form = described_class.new(params.merge(invoice: invoice))
        form.submit

        expect(invoice.reload.attributes).to include(
                                               'vat_id' => '123456789',
                                               'country' => 'Germany',
                                               'company_name' => 'Test Company',
                                               'invoice_date' => Date.parse('2023-10-01'),
                                               'invoice_number' => 'INV-001',
                                               'street' => 'Test Street',
                                               'street_number' => '123',
                                               'postal_code' => '12345',
                                               'city' => 'Test City',
                                               'invoice_has_word_invoice' => true
                                             )
        expect(invoice.line_items.first.attributes).to include(
                                                         'traveler_name' => 'John Doe',
                                                         'start_date' => Date.parse('2023-10-01'),
                                                         'end_date' => Date.parse('2023-10-05'),
                                                         'description' => 'Hotel stay',
                                                         'category' => 'hotel',
                                                         'quantity' => 1,
                                                         'unit_price' => 100.00
                                                       )
      end
    end

    context 'with invalid parameters' do
      it 'does not update the invoice and responds error' do
        Invoices::DetailsForm::INVOICE_ATTRIBUTES.each do |field|
          form = described_class.new(params.merge(invoice: invoice, field => nil))
          form.submit

          expect(invoice.reload.send(field)).to eq(nil)
          expect(form.errors[field]).to include("can't be blank")
        end
      end
    end
  end
end

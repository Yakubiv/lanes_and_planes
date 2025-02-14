require "rails_helper"

RSpec.describe "Invoice processing", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  context 'when invoice is pending' do
    let!(:invoice) { create(:invoice, status: :pending) }

    it 'processes invoice' do
      visit invoice_path(invoice)

      click_on 'Process'

      expect(page).to have_current_path(invoice_processes_path(invoice))
      expect(page).to have_content('Connect the correct booking item ID')

      fill_in 'Booking item', with: '12345678'
      click_on 'Go To Next Step →'

      expect(page).to have_content('Verify the booking')
      expect(page).to have_selector("form[action='/invoices/#{invoice.id}/processes?step=verify_booking']")

      find('input[name="invoices_verify_booking_form[booking_verified]"]').check
      find('input[name="invoices_verify_booking_form[receiving_company_verified]"]').check
      find('input[name="invoices_verify_booking_form[same_country]"]').check

      click_on 'Go To Next Step →'

      expect(page).to have_content('Add additional invoice details')

      fill_in 'Invoice Number', with: '123456'
      fill_in 'Invoice Date', with: '2025-01-01'
      fill_in 'Company Name', with: 'Test Company'
      fill_in 'VAT ID or Tax Number', with: '1234567890'
      fill_in 'Street Name', with: 'Test Street'
      fill_in 'Street Number', with: '123'
      fill_in 'Postal code', with: '12345'
      fill_in 'City', with: 'Test City'

      fill_in 'Name of Traveler', with: 'Test name'
      fill_in 'Start Date', with: '2025-01-01'
      fill_in 'End Date', with: '2025-02-02'
      fill_in 'Description', with: 'Test Destination'
      select 'hotel', from: 'Category'
      fill_in 'Unit Price', with: 123
      fill_in 'Quantity', with: 1

      click_on 'Go To Next Step →'

      expect(page).to have_content("#{invoice.filename} was successfully processed")
      expect(page).to have_current_path(invoices_path)
    end
  end
end

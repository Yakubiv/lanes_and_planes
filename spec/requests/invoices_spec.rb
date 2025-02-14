require 'rails_helper'

RSpec.describe 'Invoices', type: :request do
  describe "INDEX" do
    it "should render index page" do
      get invoices_path

      expect(response).to render_template :index
    end

    context 'when there is no invoices' do
      it 'should render empty state' do
        get invoices_path

        expect(response.body).to include(I18n.t('invoices.empty_title'))
      end
    end

    context 'when there are some invoices' do
      let!(:invoice) { create(:invoice, status:) }
      let(:status) { 'pending' }

      it 'should render invoices' do
        get invoices_path

        expect(response.body).to include(invoice.filename)
        expect(response.body).to include(invoice.status)
      end

      context 'when invoice is wrong' do
        let(:status) { 'wrong' }

        it 'does not render process button' do
          get invoices_path

          expect(response.body).not_to include('process')
        end
      end
    end
  end

  describe 'GET#SHOW' do
    let(:invoice) { create(:invoice) }

    it 'should render show page' do
      get invoice_path(invoice)

      expect(response).to render_template :show
    end

    it 'should render invoice details' do
      get invoice_path(invoice)

      expect(response.body).to include(invoice.filename)
      expect(response.body).to include(invoice.status)
    end

    context 'when invoice is pending' do
      it 'shows process button' do
        get invoice_path(invoice)

        expect(response.body).to include('process')
      end
    end

    context 'when invoice is wrong' do
      let(:invoice) { create(:invoice, status: 'wrong') }

      it 'does not show process button' do
        get invoice_path(invoice)

        expect(response.body).not_to include('process')
      end
    end
  end

  describe 'POST#create' do
    it 'should create a new invoice' do
      expect do
        post invoices_path, params: { invoice: attributes_for(:invoice) }
      end.to change(Invoice, :count).by(1)
    end

    it 'should redirect to the invoice page' do
      post invoices_path, params: { invoice: attributes_for(:invoice) }

      expect(response).to redirect_to(invoice_path(Invoice.last))
    end
  end

  describe 'PUT#update' do
    let(:invoice) { create(:invoice) }

    it 'should update invoice status' do
      put invoice_path(invoice), params: { invoice: { status: 'wrong' }, format: :turbo_stream }

      expect(invoice.reload.status).to eq('wrong')
    end

    it 'should redirect to invoices page' do
      put invoice_path(invoice), params: { invoice: { status: 'wrong' }, format: :turbo_stream }

      expect(flash[:notice]).to eq "#{invoice.filename} was marked as invalid"
      expect(response).to have_http_status(:success)
    end
  end
end

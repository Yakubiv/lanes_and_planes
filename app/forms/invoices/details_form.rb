module Invoices
  class DetailsForm
    include ActiveModel::Model

    INVOICE_ATTRIBUTES = %i[country vat_id company_name invoice_date invoice_number street street_number postal_code city invoice_has_word_invoice].freeze

    attr_accessor *INVOICE_ATTRIBUTES, :invoice, :line_items_attributes
    validates *INVOICE_ATTRIBUTES, presence: true

    def initialize(params= {})
      super(params)

      INVOICE_ATTRIBUTES.each do |field|
        instance_variable_set("@#{field}", params[field] || invoice.send(field))
      end
    end

    def submit
      return false if invalid?

      invoice.update(invoice_attributes)
    end

    private

    def invoice_attributes
      {
        country: country,
        vat_id: vat_id,
        company_name: company_name,
        invoice_date: invoice_date,
        invoice_number: invoice_number,
        street: street,
        street_number: street_number,
        postal_code: postal_code,
        city: city,
        invoice_has_word_invoice: invoice_has_word_invoice,
        line_items_attributes: line_items_attributes
      }
    end
  end
end
module Invoices
  class VerifyBookingForm
    include ActiveModel::Model
    INVOICE_FIELDS = %i[booking_verified receiving_company_verified same_country].freeze

    attr_accessor *INVOICE_FIELDS, :invoice

    validates :booking_verified, :receiving_company_verified, acceptance: true
    validates :same_country, :invoice, presence: true

    def initialize(params= {})
      super(params)

      INVOICE_FIELDS.each do |field|
        instance_variable_set("@#{field}", params[field] || invoice&.send(field))
      end
    end

    def submit
      return false if invalid?

      @invoice.update(booking_verified: booking_verified, receiving_company_verified: receiving_company_verified, same_country: same_country)
    end
  end
end

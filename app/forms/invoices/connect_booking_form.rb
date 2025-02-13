module Invoices
  class ConnectBookingForm
    include ActiveModel::Model

    attr_accessor :booking_id, :invoice

    validates :booking_id, presence: true

    def initialize(params= {})
      super(params)
      @booking_id = params[:booking_id] || invoice.booking&.booking_id
    end

    def submit
      return false if invalid?

      create_booking
      attach_booking_to_invoice
    end

    private

    def attach_booking_to_invoice
      invoice.update!(booking_id: @booking.id)
    end

    def create_booking
      @booking = Booking.find_or_create_by(booking_id: booking_id)
      @booking.update!(
        hotel_name: Faker::Company.name,
        traveler_name: Faker::Name.name,
        check_in: Faker::Date.forward(days: 23),
        check_out: Faker::Date.forward(days: 30),
        company_name: Faker::Company.name,
        street: Faker::Address.street_name,
        city: Faker::Address.city,
        zip: Faker::Address.zip_code,
        country: Faker::Address.country,
        street_number: Faker::Address.building_number
      )
      @booking
    end
  end
end
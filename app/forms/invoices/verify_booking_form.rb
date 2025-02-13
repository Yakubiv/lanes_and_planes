module Invoices
  class VerifyBookingForm
    include ActiveModel::Model

    attr_accessor :booking_id, :invoice

    validates :booking_id, presence: true

    # delegate :attributes=, to: :invoice, prefix: true

    def submit
      return false if invalid?

      attach_booking_to_invoice
    end

    def next_step

    end

    private

    def attach_booking_to_invoice
      invoice.booking_id = booking.id
      invoice.save
    end

    def booking
      # return false unless booking_id
      @booking = Booking.find_or_create_by(reference_id: booking_id)
      @booking.update(
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
    end
  end
end

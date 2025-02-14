module Invoices
  class ConnectBookingForm
    include ActiveModel::Model

    attr_accessor :booking_id, :invoice

    validates :booking_id, presence: true
    validate :booking_exists

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

    def booking_exists
      @response = Providers::BookingApi.instance.get_booking_details(booking_id)
      return true if @response

      errors.add(:booking_id, "can't be found")
    end

    def create_booking
      booking_data = @response['data'].first
      accommodation_details = booking_data['accommodation_details']
      location = accommodation_details['location']

      @booking = Booking.find_or_create_by(booking_id: booking_data['reservation'])
      @booking.update!(
        hotel_name: accommodation_details['name'],
        traveler_name: booking_data['products'].first['guests'].first['name'],
        check_in: booking_data['checkin'],
        check_out: booking_data['checkout'],
        company_name: accommodation_details['name'],
        street: location['address'],
        city: location['city'],
        zip: location['post_code'],
        country: location['country'],
        street_number: location['address'].split(' ').last
      )
      @booking
    end
  end
end
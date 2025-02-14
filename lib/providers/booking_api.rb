require 'json'
require 'uri'
require 'net/http'
require 'openssl'

module Providers
  class BookingApi
    include Singleton

    # bearer_auth_token = 'YOUR_BearerAuth_token_PARAMETER'
    # url = URI('https://demandapi.booking.com/3.1/orders/details/accommodations')
    #
    # http = Net::HTTP.new(url.host, url.port)
    # http.use_ssl = true
    #
    # request = Net::HTTP::Post.new(url)
    # request['Content-Type'] = 'application/json'
    # request['X-Affiliate-Id'] = '0'
    # request['Authorization'] = 'Bearer <YOUR_string_HERE>'
    # request.body = {
    #   currency: 'USD',
    #   extras: [
    #     'policies',
    #     'extra_charges'
    #   ],
    #   reservations: [2321873123, 4666773123]
    # }.to_json
    #
    # response = http.request(request)
    # puts response.read_body

    def get_booking_details(booking_id)
      return false unless booking_id == '12345678'

      JSON.parse(File.open('lib/fixtures/booking_api_response.json').read)
    end
  end
end
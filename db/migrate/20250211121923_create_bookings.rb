class CreateBookings < ActiveRecord::Migration[8.0]
  def change
    create_table :bookings do |t|
      t.string :booking_id
      t.string :hotel_name
      t.string :traveler_name
      t.datetime :check_in
      t.datetime :check_out
      t.string :company_name
      t.string :street
      t.string :city
      t.string :zip
      t.string :country
      t.string :street_number

      t.timestamps
    end
  end
end

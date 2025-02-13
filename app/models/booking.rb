class Booking < ApplicationRecord
  has_many :invoices, dependent: :destroy

  validates :traveler_name, :check_in, :check_out, presence: true
end



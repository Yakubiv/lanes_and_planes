class Invoice < ApplicationRecord
  ACCEPTED_CONTENT_TYPES = %w(application/pdf).freeze
  has_one_attached :pdf do |attachable|
    attachable.variant :a4, resize_to_limit: [2772, 4211], preprocessed: true
  end

  validates :pdf, attached: true
  validates :pdf, content_type: ACCEPTED_CONTENT_TYPES
  validates :pdf, size: { greater_than: 1.kilobyte } #not empty

  belongs_to :booking, optional: true

  before_save :store_pdf_filename

  enum :status, { pending: 0, processed: 1, wrong: 2 }

  private

  def store_pdf_filename
    if pdf.attached?
      self.filename = pdf.filename.to_s
    end
  end
end

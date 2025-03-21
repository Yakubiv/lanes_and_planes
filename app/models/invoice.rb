class Invoice < ApplicationRecord
  ACCEPTED_CONTENT_TYPES = %w(application/pdf).freeze
  has_one_attached :pdf do |attachable|
    attachable.variant :a4, resize_to_limit: [2772, 4211], preprocessed: true
  end

  belongs_to :booking, optional: true
  has_many :line_items, dependent: :destroy
  accepts_nested_attributes_for :line_items, allow_destroy: true, reject_if: :all_blank

  validates :pdf, attached: true
  validates :pdf, content_type: ACCEPTED_CONTENT_TYPES
  validates :pdf, size: { greater_than: 1.kilobyte } #not empty

  before_save :store_pdf_filename

  enum :status, { pending: 0, processed: 1, wrong: 2 }

  private

  def store_pdf_filename
    if pdf.attached?
      self.filename = pdf.filename.to_s
    end
  end
end

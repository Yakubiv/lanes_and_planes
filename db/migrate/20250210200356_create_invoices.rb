class CreateInvoices < ActiveRecord::Migration[8.0]
  def change
    create_table :invoices do |t|
      t.references :booking
      t.integer :status, default: 0
      t.string :filename
      t.boolean :booking_verified, default: false
      t.boolean :receiving_company_verified, default: false
      t.boolean :same_country, default: false

      t.string :country
      t.string :vat_id
      t.string :company_name
      t.datetime :invoice_date
      t.string :invoice_number
      t.string :street
      t.string :street_number
      t.string :postal_code
      t.string :city
      t.boolean :invoice_has_word_invoice
      t.decimal :total_price, precision: 10, scale: 2
      t.decimal :subtotal_price, precision: 10, scale: 2

      t.timestamps
    end
  end
end

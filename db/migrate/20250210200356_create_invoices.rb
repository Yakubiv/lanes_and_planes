class CreateInvoices < ActiveRecord::Migration[8.0]
  def change
    create_table :invoices do |t|
      t.references :booking
      t.integer :status, default: 0
      t.string :filename
      t.boolean :booking_verified, default: false
      t.boolean :receiving_company_verified, default: false
      t.boolean :same_country, default: false

      t.timestamps
    end
  end
end

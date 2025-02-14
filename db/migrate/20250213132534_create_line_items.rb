class CreateLineItems < ActiveRecord::Migration[8.0]
  def change
    create_table :line_items do |t|
      t.references :invoice
      t.string :traveler_name, null: false
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.text :description
      t.integer :category, null: false
      t.integer :quantity, null: false
      t.decimal :unit_price, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end

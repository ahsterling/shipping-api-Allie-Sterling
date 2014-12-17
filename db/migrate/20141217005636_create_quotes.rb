class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.string :service
      t.string :delivery_type
      t.integer :price_in_cents
      t.integer :total_weight
      t.string :dest_street
      t.string :dest_city
      t.string :dest_state
      t.string :dest_zip
      t.string :dest_country
      t.integer :days_to_ship

      t.timestamps
    end
  end
end

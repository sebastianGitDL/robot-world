class CreateStoreItemsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :stock_items do |t|
      t.references :stock_location
      t.references :car_model
      t.integer :stock, default: 0


      t.timestamps
    end
  end
end

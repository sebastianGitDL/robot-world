class CreateCarPrototypesTable < ActiveRecord::Migration[5.2]
  def change
    create_table :car_models do |t|
      t.string :name
      t.integer :year, limit: 4
      t.decimal :price, precision: 10, scale: 2, default: 0.0
      t.decimal :price_cost, precision: 10, scale: 2, default: 0.0

      t.timestamps

      t.index :name
      t.index :year
    end
  end
end

class CreateOrdersTable < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.date :order_date
      t.string :status, default: 'not_processed'
      t.references :car_model
      t.decimal :total, precision: 10, scale: 2, default: 0.0

      t.timestamps
    end
  end
end

class CreateCarPartsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :car_parts do |t|
      t.string :part_type
      t.boolean :defective, default: false
      t.references :car

      t.timestamps
    end
  end
end

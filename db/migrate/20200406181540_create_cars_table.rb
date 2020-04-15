class CreateCarsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :cars do |t|
      t.string :state, default: 'basic_structure'

      t.references :car_model
      t.timestamps
    end
  end
end

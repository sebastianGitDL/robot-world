require 'rails_helper'

describe Car do
  before(:each) do
    Fabricate.create(:factory_stock)
    Fabricate.create(:store_stock)
  end

  it 'is valid with all data' do
    expect(Fabricate.build(:car)).to be_valid
  end

  it 'should add stock to factory when complete' do
    car = Fabricate.create(:car)

    car.set_as_electronic_devise
    car.set_as_painting_and_final_details
    car.set_as_complete

    expect(car.car_model.available_stock('factory_stock')).to eq(1)
    expect(car.car_model.available_stock('store_stock')).to eq(0)
  end

  it 'should move stock from factory to stock when ready_to_be_sold' do
    car = Fabricate.create(:car)
    car.set_as_electronic_devise
    car.set_as_painting_and_final_details
    car.set_as_complete
    car.set_as_ready_to_be_sold

    expect(car.car_model.available_stock('factory_stock')).to eq(0)
    expect(car.car_model.available_stock('store_stock')).to eq(1)
  end
end

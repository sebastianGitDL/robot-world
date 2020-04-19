require 'rails_helper'

describe CarModel do
  context 'Builder' do
    before(:each) do
      Fabricate.create(:factory_stock)
      Fabricate.create(:store_stock)
      Fabricate.create(:car_model)

      RobotWorld::Application.load_tasks
    end

    it 'should create 10 cars.' do
      expect { Rake::Task['robot:builder'].invoke }.to change(Car, :count).by(10)
    end
  end

  context 'Guard' do
    before(:each) do
      Fabricate.create(:factory_stock)
      Fabricate.create(:store_stock)

      RobotWorld::Application.load_tasks
    end

    it 'should move stock from factory to store' do
      car = Fabricate.create(:car_completed)
      expect(car.car_model.available_stock('factory_stock')).to eq 1
      expect(car.car_model.available_stock('store_stock')).to eq 0
      Rake::Task['robot:guard'].invoke
      expect(car.reload.car_model.available_stock('factory_stock')).to eq 0
      expect(car.car_model.available_stock('store_stock')).to eq 1
    end
  end
end

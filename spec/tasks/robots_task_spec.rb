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
end

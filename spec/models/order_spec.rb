require 'rails_helper'

describe Order do
  it 'is valid with all data' do
    expect(Fabricate.build(:car)).to be_valid
  end

  context 'checkout' do
    before(:each) do
      Fabricate.create(:factory_stock)
      Fabricate.create(:store_stock)
      Fabricate.create(:car_ready_to_be_sold)
    end

    it 'creates order as purchased' do
      car_model = CarModel.first
      expect(car_model.available_stock?).to be true

      order = Order.checkout(car_model.id)

      expect(order).not_to be_nil
      expect(order.status).to eq('purchased')
    end

    context 'if there is not enough store stock' do
      it 'creates order as pending if enough factory stock' do
        car_model = CarModel.first

        car_model.add_stock('store_stock', -1, 'testing')
        car_model.add_stock('factory_stock', 1, 'testing')

        expect(car_model.available_stock?).not_to be true
        expect(car_model.available_stock?('factory_stock')).to be true

        order = Order.checkout(car_model.id)

        expect(order).not_to be_nil
        expect(order.status).to eq('pending')
      end

      it 'does not create order if not enough factory stock' do
        car_model = CarModel.first

        car_model.add_stock('store_stock', -1, 'testing')

        expect(car_model.available_stock?).not_to be true
        expect(car_model.available_stock?('factory_stock')).not_to be true

        order = Order.checkout(car_model.id)

        expect(order).to be_nil
      end
    end
  end
end

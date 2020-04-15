require 'rails_helper'

describe CarModel do
  it 'is valid with all data' do
    expect(Fabricate.build(:car_model)).to be_valid
  end

  it 'should not allow same model with same year' do
    Fabricate.create(:car_model)
    car_model_dup = Fabricate.build(:car_model)
    expect(car_model_dup.valid?).not_to be true
    expect(car_model_dup.errors.messages[:name]).to include 'There is already a car model for this year'
  end

  it 'should not allow car models with negative price' do
    car_model = Fabricate.build(:car_model, price: -10)
    expect(car_model.valid?).not_to be true
    expect(car_model.errors.messages[:price]).to include 'must be greater than 0'
  end

  it 'should not allow car models with negative price_cost' do
    car_model = Fabricate.build(:car_model, price_cost: -10)
    expect(car_model.valid?).not_to be true
    expect(car_model.errors.messages[:price_cost]).to include 'must be greater than 0'
  end

  context 'on creation' do
    it 'should create stock items' do
      factory = Fabricate.create(:factory_stock)
      store   = Fabricate.create(:store_stock)

      car_model = Fabricate.build(:car_model)
      expect { car_model.save }.to change(StockItem, :count).by(2)
      expect(car_model.stock_items.where(stock_location_id: factory.id).count).to equal 1
      expect(car_model.stock_items.where(stock_location_id: store.id).count).to equal 1
    end
  end

  context 'available_stock? method' do
    before(:each) do
      Fabricate.create(:factory_stock)
      Fabricate.create(:store_stock)
    end

    it 'returns true if there is available stock' do
      car_model = Fabricate.create(:car_model)
      car_model.add_stock('store_stock', 10, 'test')
      expect(car_model.available_stock?).to be_equal(true)
    end

    it 'returns false if there is not enough stock (stock = 0)' do
      car_model = Fabricate.create(:car_model)
      expect(car_model.available_stock?).to be_equal(false)
    end
  end

  context 'add_stock method' do
    before(:each) do
      Fabricate.create(:factory_stock)
      Fabricate.create(:store_stock)
    end

    it 'returns true if stock was added' do
      car_model = Fabricate.create(:car_model)

      expect(car_model.add_stock('store_stock', 10, 'test')).to be(true)
      expect(car_model.available_stock).to be_equal(10)
    end

    it 'returns false when trying to remove more than available stock' do
      car_model = Fabricate.create(:car_model)

      expect(car_model.add_stock('store_stock', -999, 'test')).to be(false)
    end
  end
end

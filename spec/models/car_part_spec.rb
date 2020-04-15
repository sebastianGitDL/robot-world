require 'rails_helper'

describe CarPart do
  it 'is valid with all data' do
    car = Fabricate.create(:car)
    expect(Fabricate.build(:car_part_chassis, car: car)).to be_valid
  end

  it 'does not allow a part_type that is not included in list' do
    car = Fabricate.create(:car)
    car_part = Fabricate.build(:car_part_chassis, car: car, part_type: 'random')
    expect(car_part.valid?).not_to be true
    expect(car_part.errors.messages[:part_type]).to include 'is not a valid part.'
  end
end

Fabricator(:car) do
  car_model { CarModel.first || Fabricate.create(:car_model) }
  after_create do |car|
    Fabricate.create(:car_part_chassis, car: car)
    4.times { Fabricate.create(:car_part_wheel, car: car) }
    2.times { Fabricate.create(:car_part_seat, car: car) }
    Fabricate.create(:car_part_laser, car: car)
    Fabricate.create(:car_part_computer, car: car)
    Fabricate.create(:car_part_engine, car: car)
  end
end

Fabricator(:car_completed, from: :car) do
  after_create do |car|
    car.set_as_electronic_devise
    car.set_as_painting_and_final_details
    car.set_as_complete
  end
end

Fabricator(:car_ready_to_be_sold, from: :car_completed) do
  after_create(&:set_as_ready_to_be_sold)
end

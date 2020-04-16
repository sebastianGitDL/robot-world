Fabricator(:car) do
  car_model { Fabricate.create(:car_model) }
end

Fabricator(:car_ready_to_be_sold, from: :car) do
  car_model { Fabricate.create(:car_model) }
  after_create do |car|
    car.set_as_electronic_devise
    car.set_as_painting_and_final_details
    car.set_as_complete
    car.set_as_ready_to_be_sold
  end
end

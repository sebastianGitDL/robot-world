Fabricator(:car) do
  car_model { Fabricate.create(:car_model) }
end

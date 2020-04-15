Fabricator(:car_part_wheel, from: :car_part) do
  part_type { 'wheel' }
end

Fabricator(:car_part_chassis, from: :car_part) do
  part_type { 'chassis' }
end

Fabricator(:car_part_laser, from: :car_part) do
  part_type { 'laser' }
end

Fabricator(:car_part_computer, from: :car_part) do
  part_type { 'computer' }
end

Fabricator(:car_part_engine, from: :car_part) do
  part_type { 'engine' }
end

Fabricator(:car_part_seat, from: :car_part) do
  part_type { 'seat' }
end

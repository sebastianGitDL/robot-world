namespace :robot do
  desc 'Cleanup robot'
  task cleaner: [:environment] do
    Car.destroy_all
  end

  desc 'Builder robot'
  task builder: [:environment] do
    10.times do
      begin
        car = Car.new car_model: CarModel.find(CarModel.pluck(:id).sample)
        car.save

        next if rand(1..10) < 2

        car.set_as_electronic_devise
        car.car_parts << CarPart.new(part_type: 'chassis')
        car.car_parts << CarPart.new(part_type: 'engine')
        4.times { car.car_parts << CarPart.new(part_type: 'wheel', defective: (rand(1..10) < 2)) }
        2.times { car.car_parts << CarPart.new(part_type: 'seat', defective: (rand(1..10) < 2)) }

        next if rand(1..10) < 2

        car.set_as_painting_and_final_details
        car.car_parts << CarPart.new(part_type: 'laser', defective: (rand(1..10) < 2))
        car.car_parts << CarPart.new(part_type: 'computer')

        next if rand(1..10) < 2

        car.set_as_complete
      rescue StandardError
        Rails.logger.error "[!] Unexpected error while creating car: #{$ERROR_INFO}"
      end
    end
  end

  desc 'Guard robot'
  # runs every 30 minutes
  task guard: [:environment] do
    Car.where_complete.find_each do |car|
      begin
        if car.defective_parts?
          Auditory.notify_slack("Car ID##{car.id} - Has defective parts.")
        else
          car.set_as_ready_to_be_sold
        end
      rescue StandardError
        Rails.logger.error "[!] Guard Robot Unexpected error while processing Car #{car.id}. Error: #{$ERROR_INFO}"
      end
    end

    Order.joins(:car_model)
         .merge(CarModel.with_avaliable_store_stock)
         .where_pending.find_each do |order|
      car_model = order.car_model.reload
      order.set_as_purchased if car_model.available_stock?
    end
  end

  desc 'Buyer robot'
  # runs every 30 minutes
  task buyer: [:environment] do
    rand(1..10).times do
      begin
        car_model = CarModel.find(CarModel.pluck(:id).sample)
        Order.checkout(car_model.id)
      rescue StandardError
        Rails.logger.error "[!] Unexpected error while creating order: #{$ERROR_INFO}"
      end
    end
  end
end

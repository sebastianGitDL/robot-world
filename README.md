## Foreword
First of all, thanks for taking the time to take this tech challenge. We really appreciate it. And now, are you ready to rumble? :)

## Robot World

It's the year 2020, the developers are part of the past. You are probably the last dev on the earth and you are pretty busy, so you decide the best is the robots can handle all the work instead of you.

## Basic structure
- **Auditory**: Simple Class to handle communication with external applications (like Slacks), and I was also intending to use it to leave messages in the logs but due to lack of time I didn't do it.
- **CarModel**: To handle logic associated to each Car's model, like the model's name, year, price and cost_price. I am assuming that the price and cost_price is associated to each model and not to the parts of each car.
- **Car**: To handle logic associated to the each Car. I have configured [state_machine](https://github.com/pluginaweek/state_machine) to handle the the status transitions and several actions that are associated to some transitions (like adding stock to the factory_stock upon completion).
- **CarPart**: Handles the logic realted to each car part (wheel, computer, chassis, etc). I am aware that this was not entirely necessary, but sinde it was simple enough I decided to do it this way. We could remove this model and handle the car parts as a new attribute within the car's model using an array atribute. I am pretty sure that doing that would probably improve performance at some point.
- **Order**: To handle Order's logic. I have also configured [state_machine](https://github.com/pluginaweek/state_machine) as well to handle states and transitions between them. Since we are not handling billing, I am assuming that the Order is "purchases" at the moment of creation.
- **StockLocation**: Used to handle the different possible warehouses we can have. It was not needed for this particular case, since based on the description the amount of locations is static, but having this Model would eventually allow us to scale or add more locations if needed (specially since there are several stores).
- **StockItem**: This model is intended to save the stock amounts of each car model within each warehouse. 

## Robots
The logic associated to the robots is being handled within different rake tasks that I have created within the `lib/tasks/robot_tasks.rb` file. Additionally, I have configured the [whenever](https://github.com/javan/whenever) to run each robot every X amount of time, accordingly to the each robot's description. This way I don't have to handle time managements within each robot.

**Builder Robot**: On relation on how it creates the cars. I decided to simulate step by step the creation process proposed in the challenge and between each step add a check to validate if it should follow based on a random number. I also did the same when adding each car part to the car to decide if the part is defective or not.

## #1 Problem
Within the **Order** model I included a method to handle the checkout, where it basically handles the logic associated to the order's creation and validation. I think that one possible solution for this would be to perform some changes on the Order model to extend that the checkout logic and also the Guard Robot's tasks. Here is a list of actions I will perform: 
- Configure Order model to support two possible status: `purchase` and `pending`. The former one would be associated to orders where there is enough stock for the car model. While the later would be used to mark those orders associated to car models where there is not enough stock in the store, but there is still stock in the factory.
- Extend checkout process to also validate stock in both warehouses, and make sure to create the orders in `pending` status if there is not enough stock in the Store Warehouse but there is stock in the Factory Warehouse.
- Extend the guard robot to also check for orders in `pending` status after moving the Stock. Then proceed to set as `purchased` each order where there is available stock.

## #2 Problem
I would suggest supporting an API method to handle these updates. Here are some proposed changes:
- add a new API controller like `app/controllers/api/v1/orders_controller.rb`
- configure [devise](https://github.com/heartcombo/devise) to handle authorizations. I will try to configure it, but that would depend on times. 
- Add new method within the **Order** model to handle validations and actions associated to this change (change the car model associated, update total, vlaidate stock, etc).

## PLUS
TBD

## Automated Tests
I have written some automated tests using rspec and also using the [Fabrication](www.fabricationgem.org) gem to handle factories. I have not configured Faker gem to generate example data for the test since I don't think it would be necessary for this particular challenge.
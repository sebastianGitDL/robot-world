# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

StockLocation.create(name: 'factory_stock')
StockLocation.create(name: 'store_stock')

%w[Acura FIAT Ford Audi Bentley BMW Buick Cadillac Chevrolet Chrysler Dodge].each do |model|
  [1990, 1995, 2000, 2005, 2010, 2015, 2020].each do |year|
    price     = rand(10000..150000)
    car_model = CarModel.create(name: model, year: year, price: price, price_cost: price*0.80)
  end
end

CarPart.create(part_type: 'wheel')
CarPart.create(part_type: 'chassis')
CarPart.create(part_type: 'laser')
CarPart.create(part_type: 'computer')
CarPart.create(part_type: 'engine')
CarPart.create(part_type: 'seat')
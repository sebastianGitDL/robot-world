class StockLocation < ActiveRecord::Base
  has_many :stock_items

  validates :name, presence: true, uniqueness: true

  after_create :create_stock_items_for_models

  private

  def create_stock_items_for_models
    CarModel.all.each do |model|
      stock_items << StockItem.new(car_model_id: model.id)
    end
  end
end

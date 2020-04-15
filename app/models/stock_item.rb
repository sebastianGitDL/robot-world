class StockItem < ActiveRecord::Base
  belongs_to :car_model
  belongs_to :stock_location

  validates :stock, presence: true, numericality: { greater_than_or_equal_to: 0 }
end

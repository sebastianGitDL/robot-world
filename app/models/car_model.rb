class CarModel < ActiveRecord::Base
  has_many :cars
  has_many :stock_items

  validates :name, uniqueness: { scope: :year, message: 'There is already a car model for this year' }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :price_cost, presence: true, numericality: { greater_than: 0, less_than: :price }

  after_create :create_stock_items

  scope :with_avaliable_store_stock, -> { joins(stock_items: :stock_location).where("stock_locations.name = 'store_stock' AND stock_items.stock > 0") }

  def available_stock(location_name = 'store_stock')
    stock_location_id = StockLocation.find_by(name: location_name)&.id
    return unless stock_location_id

    stock_items.find_by(stock_location_id: stock_location_id).stock
  end

  def available_stock?(location_name = 'store_stock')
    available_stock(location_name)&.positive?
  end

  def add_stock(stock_location_name, amount, reason)
    stock_location_id = StockLocation.find_by(name: stock_location_name)&.id
    unless stock_location_id
      Rails.logger.info "[CarModel ID##{id}] Stock Location Does not exists. Stock Location: #{stock_location_name}, amount: #{amount}"
      return false
    end

    stock_item = stock_items.find_by(stock_location_id: stock_location_id)
    stock_item.with_lock do
      stock_item.reload
      if (stock_item.stock.positive? || amount.positive?) && (stock_item.stock + amount) >= 0
        StockItem.where(id: stock_item.id).update_all "stock = stock + #{amount}"
        Rails.logger.info "[CarModel ID##{id}] Stock #{stock_location_name} Updated #{stock_item.stock} -> #{stock_item.stock + amount}. Reason: #{reason}"
        true
      else
        Rails.logger.info "[CarModel ID##{id}] was not updated. Stock Location: #{stock_location_name}, amount: #{amount}, reason: #{reason}"
        false
      end
    end
  end

  private

  def create_stock_items
    StockLocation.all.each do |stock_location|
      stock_items << StockItem.new(stock_location_id: stock_location.id)
    end
  end
end

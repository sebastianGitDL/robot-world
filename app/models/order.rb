class Order < ActiveRecord::Base
  belongs_to :car_model

  validates :total, presence: true, numericality: { greater_than: 0 }
  validates :order_date, presence: true

  scope :where_pending, -> { where(status: 'pending') }

  state_machine :status, initial: :not_processed do
    state :not_processed
    state :pending
    state :purchased

    after_transition %i[not_processed pending] => :purchased, do: :remove_stock

    event :set_as_pending do
      transition not_processed: :pending
    end

    event :set_as_purchased do
      transition %i[pending not_processed] => :purchased
    end
  end

  def self.checkout(car_model_id)
    car_model = CarModel.find_by(id: car_model_id)

    if car_model.available_stock?('store_stock') || car_model.available_stock?('factory_stock')
      order = Order.new car_model_id: car_model.id,
                        total: car_model.price,
                        order_date: Time.current
      order.save

      car_model.available_stock? ? order.set_as_purchased : order.set_as_pending
      order
    else
      Rails.logger.error "[#{car_mode.id}] Order#checkout error: not enough stock"
      nil
    end
  rescue StandardError
    Rails.logger.error "[!] Order#checkout Unexpected error: #{$ERROR_INFO}"
    nil
  end

  def change_car_model(model_name, year)
    new_car_model = CarModel.find_by name: model_name, year: year

    if new_car_model
      if new_car_model.available_stock?
        new_car_model.add_stock('store_stock', -1, "Order Update: Removing from Order #{id}")
        car_model.add_stock('store_stock', 1, "Order Update: Adding to Order #{id}")
        self.car_model_id = new_car_model.id
        self.total        = new_car_model.price

        if save
          { code: 200, message: I18n.t('messages.orders.update_success') }
        else
          { code: 400, message: I18n.t('messages.orders.update_fail', error_messages: errors.messages.map { |k, v| "#{k}: #{v.join(',')}" }.join('. ')) }
        end
      else
        { code: 400, message: I18n.t('messages.orders.update_fail', error_messages: 'There is no available stock in the store.') }
      end
    else
      { code: 404, message: I18n.t('messages.orders.update_fail', error_messages: 'Car model does not exists') }
    end
  rescue StandardError
    Rails.logger.error "[!] Order#change_car_model Unexpected error: #{$ERROR_INFO}"
    { code: 500, message: I18n.t('messages.unexpected_error') }
  end

  private

  def remove_stock
    car_model.add_stock('store_stock', -1, 'Order Purchased')
  end
end

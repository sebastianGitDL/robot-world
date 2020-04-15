class Car < ActiveRecord::Base
  has_many  :car_parts
  belongs_to :car_model, required: true

  scope :where_complete, -> { where(state: 'complete') }

  state_machine :state, initial: :basic_structure do
    state :basic_structure
    state :electronic_devise
    state :painting_and_final_details
    state :complete
    state :ready_to_be_sold

    after_transition painting_and_final_details: :complete, do: :add_stock_to_factory
    after_transition complete: :ready_to_be_sold, do: :move_stock_to_store

    event :set_as_electronic_devise do
      transition basic_structure: :electronic_devise
    end

    event :set_as_painting_and_final_details do
      transition electronic_devise: :painting_and_final_details
    end

    event :set_as_complete do
      transition painting_and_final_details: :complete
    end

    event :set_as_ready_to_be_sold do
      transition complete: :ready_to_be_sold
    end
  end

  def defective_parts?
    !car_parts.find_by(part_type: 'computer').check_car_status!
  end

  private

  def add_stock_to_factory
    car_model.add_stock('factory_stock', 1, 'Car completed')
  end

  def move_stock_to_store
    raise 'Error moving the stock' unless car_model.add_stock('factory_stock', -1, 'Moving Car to store') && car_model.add_stock('store_stock', 1, 'Moving Car to store')
  end
end

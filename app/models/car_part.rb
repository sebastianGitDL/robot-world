class CarPart < ActiveRecord::Base
  belongs_to :car

  AVAILABLE_TYPES = %w[chassis engine wheel seat laser computer].freeze

  validates :part_type, inclusion: { in: AVAILABLE_TYPES, message: 'is not a valid part.' }
  validate :amount_of_parts, on: :create

  def check_car_status!
    raise 'not implemented' if part_type != 'computer'

    CarPart.find_by(car_id: car_id, defective: true).blank?
  end

  private

  def amount_of_parts
    case part_type
    when 'chassis'
      errors.add(:car, 'Car already has a chassis') if CarPart.find_by(car_id: car_id, part_type: 'chassis')
    when 'engine'
      errors.add(:car, 'Car already has an engine') if CarPart.find_by(car_id: car_id, part_type: 'engine')
    when 'wheel'
      errors.add(:car, 'Car already has 4 wheels') if CarPart.where(car_id: car_id, part_type: 'engine').count == 4
    when 'seat'
      errors.add(:car, 'Car already has 4 seats') if CarPart.where(car_id: car_id, part_type: 'seat').count == 2
    when 'computer'
      errors.add(:car, 'Car already has a computer') if CarPart.find_by(car_id: car_id, part_type: 'computer')
    end
  end

end

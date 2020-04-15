class ApiController < ActionController::Base
  ##
  # This method allows to update an order's model
  #
  # @resource /api/v1/orders/:id/update
  # @action PUT
  #
  # @required [String] car_model : JSON formated data that should include model_name and year.
  # @required [Integer] id : Order's id to update
  def update
    order     = Order.find params[:id]
    response  = order.change_car_model(params[:car_model][:model_name], params[:car_model][:year])

    render json: { code: response[:code], message: response[:message] }
  rescue ActiveRecord::NotFound
    render json: { code: 404, message: 'Review information provided.' }, status: 404
  end
end

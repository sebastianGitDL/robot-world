module Api
  module V1
    class OrdersController < ActionController::Base

      ##
      # This method allows to update an order's model
      #
      # @resource /api/v1/orders/:id/update
      # @action PUT
      #
      # @required [String] car_model : JSON formated data that should include name and year.
      # @required [Integer] id : Order's id to update
      # @response_field [String] code Code related to the method result.
      # @response_field [String] message Shows the method results and also informs the errors.
      def update
        order     = Order.find params[:id]
        response  = order.change_car_model(params[:car_model][:name], params[:car_model][:year])

        render json: { code: response[:code], message: response[:message] }
      rescue ActiveRecord::RecordNotFound
        render json: { code: 404, message: I18n.t('api.orders.not_found') }, status: 404
      end
    end
  end
end

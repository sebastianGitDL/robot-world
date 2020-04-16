require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :controller do
  def put_update(order_id, car_model_data)
    put :update, params: { use_route: "/api/v1/orders/#{order_id}/update",
                           id: order_id,
                           car_model: car_model_data,
                           format: :json }
  end

  context 'Update method', validToken: true do
    before(:each) do
      Fabricate.create(:factory_stock)
      Fabricate.create(:store_stock)
    end

    it 'updates the order correctly' do
      model_ford  = Fabricate.create(:car_model, name: 'Ford')
      model_fiat  = Fabricate.create(:car_model, name: 'FIAT')
      Fabricate.create(:car_ready_to_be_sold, car_model: model_ford)
      Fabricate.create(:car_ready_to_be_sold, car_model: model_fiat)
      order = Order.checkout(model_ford.id)

      put_update(order.id, name: model_fiat.name, year: model_fiat.year)
      expect(response.status).to eq 200
      expect(JSON.parse(response.body)['code']).to eq(200)
      expect(JSON.parse(response.body)['message']).to eq(I18n.t('messages.orders.update_success'))
      expect(order.reload.car_model_id).to eq(model_fiat.id)
    end

    it 'returns 404 error when order does not exists' do
      put_update(9999, name: 'random name', year: '2000')
      expect(response.status).to eq 404
      expect(JSON.parse(response.body)['code']).to eq(404)
      expect(JSON.parse(response.body)['message']).to eq(I18n.t('api.orders.not_found'))
    end
  end
end

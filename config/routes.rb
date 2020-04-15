Rails.application.routes.draw do
  namespace :api do
    scope :v1 do
      match 'orders/:id/update' => 'orders#update', as: 'update', :via => [:put]
    end
  end
end

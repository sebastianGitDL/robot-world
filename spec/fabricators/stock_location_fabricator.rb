Fabricator(:factory_stock, from: :stock_location) do
  name { 'factory_stock' }
end

Fabricator(:store_stock, from: :stock_location) do
  name { 'store_stock' }
end
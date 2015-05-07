json.array!(@customers) do |customer|
  json.extract! customer, :id, :agent_id, :phone_number
  json.url customer_url(customer, format: :json)
end

json.array!(@messages) do |message|
  json.extract! message, :id, :to, :from, :agent_id, :customer_id, :text, :msg_type
  json.url message_url(message, format: :json)
end

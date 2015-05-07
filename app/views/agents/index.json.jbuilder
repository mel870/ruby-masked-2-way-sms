json.array!(@agents) do |agent|
  json.extract! agent, :id, :bw_phone_number, :agent_phone_number
  json.url agent_url(agent, format: :json)
end

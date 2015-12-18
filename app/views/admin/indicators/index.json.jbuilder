json.array!(@indicators) do |indicator|
  json.extract! indicator, :indicator_name, :indicator_value
  json.url indicator_url(indicator, format: :json)
end
